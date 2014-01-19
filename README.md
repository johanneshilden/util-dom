util-dom
========

Basic DOM manipulation API for Fay (faylang: [https://github.com/faylang/fay/wiki](https://github.com/faylang/fay/wiki)). 

This module provides a trivial `Element` data type and some basic FFI wrappers for a few of the standard JavaScript DOM functions (feel free to add more). It does not depend on jQuery or other third-party JavaScript libraries.

    -- | Represents a DOM element.
    data Element

## Functions

* createElement
* appendChild
* setAttribute
* onLoad
* documentBody
* addWindowEvent
* toString
* innerHtml
* outerHtml
* getElementById
* getElementsByClassName
* getElementsByTagName
* setElementHtml
* addEventListener
* addElementEventListener
* onClick

### createElement

    createElement :: String -> Fay Element

Create an element with the specified name.

**Example:**

    el <- createElement "button"

### appendChild

Add an element after the last child node of the specified element.

    appendChild :: Element    -- ^ Parent node
                -> Element    -- ^ The child element
                -> Fay ()


### setAttribute

Add or set the attribute/value pair on the provided target element. 

    setAttribute :: Element    -- ^ An element
                 -> String     -- ^ Attribute name
                 -> String     -- ^ Attribute value
                 -> Fay ()


### onLoad

Add an "on load" event listener to the window object.

    onLoad :: Fay () -> Fay ()

**Example:**

    stuff :: Fay ()
    stuff = ...

    main :: Fay ()
    main = onLoad $ do stuff

### documentBody


Retrieve the document body element.

    documentBody :: Fay Element

### addWindowEvent

Add an event listener to the window object.

    addWindowEvent :: String   -- ^ An event type
                   -> Fay ()   -- ^ The listener function 
                   -> Fay ()

### toString

Stringify an element.

    toString :: Element -> Fay String

### innerHtml

Retrieve the HTML between the start and end tags of the object.

    innerHtml :: Element -> Fay String

### outerHtml

Return the object and its content.

    outerHtml :: Element -> Fay String

### getElementById

Similar to the JavaScript method with the same name.

    getElementById :: String -> Fay (Maybe Element)

This function returns a `Maybe Element` in the `Fay` monad to properly handle cases where no element is found matching the provided id.

**Example:**

    doStuff :: Fay ()
    doStuff = do
        el <- getElementById "my-element"
        case el of
            Nothing -> return ()
            Just e  -> doSomethingWith e

### getElementsByClassName

Return a list of elements which matches the provided class name(s).

    getElementsByClassName :: String -> Fay [Element]

### getElementsByTagName

Return a list of elements with the specified tag name.

    getElementsByTagName :: String -> Fay [Element]

### setElementHtml

Set the inner HTML of the document's body element.

    setBodyHtml :: String -> Fay ()

### addEventListener

Register an event listener on an element.

    setHtml :: Element -> String -> Fay ()

**Example:**

    createButton = do
        btn <- createButton "Hello"
        addEventListener btn "click" doStuff

### addElementEventListener

Register an event listener on the element with the specified id. Does nothing if no element exists with the provided id.

    addEventListener :: Element -> String -> Fay Bool -> Fay ()

### onClick

Register an "on click" event listener.

    onClick :: String      -- ^ The id of the event target
            -> Fay Bool    -- ^ A listener function
            -> Fay ()

## More elaborate examples

    module Examples where
    
    import Prelude
    import FFI
    import Util.DOM
    
    alert :: String -> Fay ()
    alert = ffi "alert(%1)"
    
    doStuff :: Fay Bool
    doStuff = do 
        alert "Let the drama begin!"
        return False
    
    createButton :: String -> Fay Element
    createButton title = do
        el <- createElement "button"
        setHtml el title  -- Replace inner HTML with the title
        return el
    
    -- | Uses createElement, setAttribute, addEventListener and appendChild
    example1 :: Fay ()
    example1 = do
        btn <- createButton "Hello"
        setAttribute btn "style" "border:2px solid red"
        addEventListener btn "click" doStuff
        body <- documentBody
        appendChild body btn
    
    example2 :: Fay ()
    example2 = do
        el <- createElement "div"
        setHtml el "hello"
        setAttribute el "id" "hello-div"
    
        p <- createElement "p"
        setHtml p "world"
    
        body <- documentBody
        appendChild body el
    
        div <- getElementById "hello-div"
        case div of
            Nothing -> return ()
            Just dv -> appendChild dv p
    
    setStyle :: Element -> String -> Fay ()
    setStyle element = setAttribute element "style" 
    
    -- Uses getElementByClassName, setAttribute etc.
    example3 :: Fay ()
    example3 = do
        el <- documentBody
        run (f el) [createButton $ show x | x <- [1 .. 5]]
        --
        btns <- getElementsByClassName "button-class"
        run (flip setStyle "border:2px solid yellow") btns
    
      where f :: Element -> Fay Element -> Fay ()
          f par element = do
              c <- element 
              appendChild par c
              setAttribute c "class" "button-class"
          run :: (a -> Fay ()) -> [a] -> Fay ()
          run a = sequence_ . map a 
    
    main :: Fay ()
    main = do
    onLoad $ do
        example1
        example2
        example3
    

Compile the examples:

    fay Examples.hs --html-wrapper
