{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
import Foreign.Ptr
import Foreign.C.Types
import Foreign.Marshal.Alloc
import Foreign.Storable
import Foreign.ForeignPtr
import Foreign.C.String
import Foreign.Marshal.Array
import System.IO.Unsafe

foreign import ccall "math.h abs" c_abs :: CInt -> CInt
foreign import ccall "math.h pow" c_pow :: CDouble -> CDouble -> CDouble
foreign import ccall "create_arr" c_create_array :: CInt -> IO (Ptr CInt)
foreign import ccall "stdlib.h &free" p_free :: FunPtr (Ptr a -> IO ())
foreign import ccall "swap_nums" c_swap :: Ptr CInt -> Ptr CInt -> IO()
foreign import ccall "string.h strlen" c_strlen :: CString -> CInt
foreign import capi "printf" c_printInt :: CString -> CInt -> IO()

swapTwoNums :: Int -> Int -> (Int,Int)
swapTwoNums x y = unsafePerformIO $ do
    alloca $ \ptr1 -> do
        alloca $ \ptr2 -> do
            poke ptr1 (fromIntegral x)
            poke ptr2 (fromIntegral y)
            c_swap ptr1 ptr2
            num1 <- peek ptr1
            num2 <- peek ptr2
            return(fromIntegral num1,fromIntegral num2)

getLengthString :: String -> Int
getLengthString str = unsafePerformIO $ do
    withCString str $ \str2 -> do
            return $ fromIntegral $ c_strlen str2

main :: IO ()
main = do
    print $ c_abs (-1)
    print $ c_pow 2 3
    -- pointer
    print $ swapTwoNums 23 32
    -- string
    withCString "Hello Haskello %d\n" $ \formattedString -> c_printInt formattedString 23
    print $ getLengthString "Hello Haskell!!"
   -- print array
    let size = 5
    arrayPtr <- c_create_array (fromIntegral size)
    foreignPtr <- newForeignPtr p_free arrayPtr
    array <- withForeignPtr foreignPtr $ \ptr -> peekArray size ptr
    putStrLn $ "Array: " ++ show array
