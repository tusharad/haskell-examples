{- cabal:
 build-depends: base,vector
-}
module Main where
import qualified Data.Vector.Unboxed as V

main = do
	let arr = V.enumFromTo 1 (10 :: Int)
	print $ V.length arr				-- Length of a vector
	print $ V.null arr					-- Check if vector is null or not
	print $ arr V.! 2					-- Get ith element of a vector
	print $ arr V.!? 2					-- Get ith element of a vector
	print $ V.head arr					-- Get the first element of the vector
	print $ V.last arr					-- Get the last element of the vector
	print $ V.slice 2 5 arr				-- Slice the vector from i to i+n...the vector size must be at least i+n
	print $ V.last arr					-- Get the last element of the vector
	print $ V.init arr					-- Get all but last element of the vector
	print $ V.tail arr					-- Get all but first element of the vector
	print $ V.fromList ([1..10] :: [Int])			-- Create vector from list
	print $ arr == V.fromList [1..10]	-- Compare two vectors
	--print $ V.maximumBy (comparing fst) $ V.fromList [(1,'a'),[2,'b']]				-- Convert vector to list
	-- print $ V.maximumOn (comparing fst) $ V.fromList [(1,'a'),[1,'b']]				-- Convert vector to list
	print $ V.maximum arr				-- Convert vector to list
	print $ V.product arr				-- Convert vector to list
	print $ V.sum arr				-- Convert vector to list
	-- print $ V.or arr				-- Convert vector to list
	-- print $ V.and arr				-- Convert vector to list
	print $ V.any (==3) arr				-- Convert vector to list
	print $ V.toList arr				-- Convert vector to list

	putStrLn "Hello"
