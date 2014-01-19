module Util.DOM
    ( Element
    , createElement
    , appendChild
    , setAttribute
    , onLoad
    , documentBody
    , toString
    , innerHtml
    , outerHtml
    , getElementById
    , getElementsByClassName
    , getElementsByTagName
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

-- | Create an element with the specified name.
createElement :: String -> Fay Element
createElement = ffi "document.createElement(%1)"

-- | Add an element after the last child node of the specified element.
appendChild :: Element    -- ^ Parent node
            -> Element    -- ^ The child element
            -> Fay ()
appendChild = ffi "%1.appendChild(%2)"

-- | Add or set the attribute/value pair on the provided target element. 
setAttribute :: Element    -- ^ An element
             -> String     -- ^ Attribute name
             -> String     -- ^ Attribute value
             -> Fay ()
setAttribute = ffi "%1.setAttribute(%2, %3)"

-- | Add an "on load" event listener to the window object.
onLoad :: Fay () -> Fay ()
onLoad = addWindowEvent "load"

-- | Retrieve the document body element.
documentBody :: Fay Element
documentBody = ffi "document.body"

-- | Add an event listener to the window object.
addWindowEvent :: String   -- ^ An event type
               -> Fay ()   -- ^ The listener function 
               -> Fay ()
addWindowEvent = ffi "window.addEventListener(%1, %2)"

-- | Stringify an element.
toString :: Element -> Fay String
toString = ffi "%1.toString()"

-- | Retrieve the HTML between the start and end tags of the object.
innerHtml :: Element -> Fay String
innerHtml = ffi "%1.innerHTML"

-- | Return the object and its content.
outerHtml :: Element -> Fay String
outerHtml = ffi "%1.outerHTML"

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

-- | Return a list of elements with the specified tag name.
getElementsByTagName :: String -> Fay [Element]
getElementsByTagName = ffi "document.getElementsByTagName(%1)"

-- | Set the inner HTML of the document's body element.
setBodyHtml :: String -> Fay ()
setBodyHtml html = documentBody >>= flip setHtml html 

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

