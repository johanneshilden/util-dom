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
main = onLoad $ do
    example1
    example2
    example3

