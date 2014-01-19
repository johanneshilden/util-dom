module Util.DOM
    ( Element
    , toString
    , innerHtml
    , getElementById
    , getElementsByClassName
    , setBodyHtml
    , setHtml
    , setElementHtml
    , addEventListener
    , addElementEventListener
    , onClick
    ) where

import Prelude 
import FFI

-- | Represents a DOM element.
data Element

-- | Stringify an element.
toString :: Element -> Fay String
toString = ffi "%1.toString()"

-- | Retrieve the HTML between the start and end tags of the object.
innerHtml :: Element -> Fay String
innerHtml = ffi "%1.innerHTML"

-- | Similar to the JavaScript method with the same name.
getElementById :: String -> Fay (Maybe Element)
getElementById element = do
    el <- getById element
    empty <- isEmptyObj el
    return $ if empty == False
        then Just el
        else Nothing

getById :: String -> Fay Element
getById = ffi "document.getElementById(%1)"

-- | Return a list of elements which matches the provided class name(s).
getElementsByClassName :: String -> Fay [Element]
getElementsByClassName = ffi "document.getElementsByClassName(%1)"

-- | Set the inner HTML of the document's body element.
setBodyHtml :: String -> Fay ()
setBodyHtml = ffi "document.body.innerHTML = %1"

-- | Set the inner HTML of an element. 
setHtml :: Element -> String -> Fay ()
setHtml = ffi "%1.innerHTML = %2"

-- | Replace the inner HTML of the element with the specified id.
setElementHtml :: String   -- ^ An element id
               -> String   -- ^ The HTML to insert into the element
               -> Fay ()
setElementHtml element html = do
    el <- getElementById element
    case el of 
        Nothing -> return ()      -- No such element!
        Just e  -> setHtml e html

isEmptyObj :: Element -> Fay Bool
isEmptyObj = ffi "function(obj){for(var n in obj){return false;}return true;}(%1)"

-- | Register an event listener on an element.
addEventListener :: Element -> String -> Fay Bool -> Fay ()
addEventListener = ffi "%1.addEventListener(%2, %3, false)"

-- | Register an event listener on the element with the specified id.
-- Does nothing if no element exists with the provided id.
addElementEventListener :: String    -- ^ The id of the event target
                        -> String    -- ^ The event name
                        -> Fay Bool  -- ^ A listener function
                        -> Fay ()
addElementEventListener element event go = do
    el <- getElementById element
    case el of
        Nothing -> return ()      -- No such element!
        Just e  -> addEventListener e event go

-- | Register an "on click" event listener.
onClick :: String      -- ^ The id of the event target
        -> Fay Bool    -- ^ A listener function
        -> Fay ()
onClick = flip addElementEventListener "click"

