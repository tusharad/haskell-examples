{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE CApiFFI #-}
import Data.Int
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
foreign import ccall "intToString" c_intToString :: CInt -> CString
foreign import ccall "bubbleSort" c_bubbleSort :: Ptr CInt -> CInt -> IO()
foreign import ccall "toUpper" c_toUpper :: CString -> IO()
foreign import ccall "addTwoArrays" c_addTwoArrays:: Ptr CInt -> CInt -> Ptr CInt -> Int -> IO (Ptr CInt)
foreign import ccall "addThreeArrays" c_addThreeArrays:: Ptr CInt -> CInt -> Ptr CInt -> Int -> Ptr CInt -> Int -> IO (Ptr CInt)

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

intToString :: Int -> String
intToString n = unsafePerformIO $ peekCString $ c_intToString(fromIntegral n)

bubbleSort :: [Int32] -> IO ()
bubbleSort xs = do
  let size = length xs
  alloca $ \ptr1 -> do
    pokeArray ptr1 xs
    c_bubbleSort (castPtr ptr1) (fromIntegral size) 

toUpper :: String -> IO ()
toUpper str = do
  withCString str $ \str2 -> do
    c_toUpper str2

addThreeArrays :: [Int32] -> [Int32] -> [Int32] -> [Int32]
addThreeArrays xs ys zs = unsafePerformIO $ do
  let len1 = length xs
  let len2 = length ys
  let len3 = length zs
  allocaBytes (len1*4) $ \ptr1 -> do
    pokeArray ptr1 xs
    allocaBytes (len2*4) $ \ptr2 -> do
      pokeArray ptr2 ys
      allocaBytes (len3*4) $ \ptr3 -> do
        pokeArray ptr3 zs
        arrPtr <- c_addThreeArrays (castPtr ptr1) (fromIntegral len1) (castPtr ptr2) (fromIntegral len2) (castPtr ptr3) (fromIntegral len3)
        foreignPtr <- newForeignPtr p_free arrPtr
        array <- withForeignPtr foreignPtr $ \ptr -> peekArray (len1+len2+len3) (castPtr ptr)
        return array

addTwoArrays :: [Int32] -> [Int32] -> [Int32]
addTwoArrays xs ys = unsafePerformIO $ do
  let len1 = length xs
  let len2 = length ys
  allocaBytes (len1*4) $ \ptr1 -> do
    pokeArray ptr1 xs
    print $ unsafePerformIO $ peek (plusPtr ptr1 8 :: Ptr Int32)
    print $ unsafePerformIO $ peek ptr1
    allocaBytes (len2*4) $ \ptr2 -> do
      pokeArray ptr2 ys
      arrPtr <- c_addTwoArrays (castPtr ptr1) (fromIntegral len1) (castPtr ptr2) (fromIntegral len2)
      foreignPtr <- newForeignPtr p_free arrPtr
      array <- withForeignPtr foreignPtr $ \ptr -> peekArray (len1+len2) (castPtr ptr)
      return array

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
    -- return char*
    print $ intToString 2
    -- pass int*
    bubbleSort ([4,6,3,7,1] :: [Int32])
    -- toUpper
    toUpper "tushar"
    -- merge array
    print $ addTwoArrays [1,2,3] [4,5,6]
    print $ addThreeArrays [1,2,3] [4,5,6] [7,8,9]
