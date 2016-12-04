module Main where
import Control.DeepSeq
import Control.Exception
import Control.Parallel
import Control.Parallel.Strategies
import Data.Time.Clock
import Data.List
import System.Environment
import Text.Printf


blue :: Integer -> Integer
blue n = 6*(2*4^n - 3^n)

yellow :: Integer -> Integer
yellow n = 6*(4^n*(3*n - 17) + 3^n*(2*n + 17))

g :: Integer -> Integer
g n = gcd (blue n) (yellow n)

--
-- $ ghci snowflakes.hs
-- Prelude> s(500)
--
s :: Integer -> Integer
s n = sum (map g [0..n])


parMapChunked
  :: Strategy b -- ^ evaluation degree at each element
  -> Int        -- ^ chunk size
  -> (a -> b)   -- ^ function to apply to each element
  -> [a]        -- ^ input list
  -> [b]
parMapChunked strat i f =
    withStrategy (parListChunk i strat) . map f


--
-- $ ghc snowflakes.hs -O2 -threaded -rtsopts
-- $ ./snowflakes +RTS -N -s
--

main = do
    let length      = 10^7
        chunkSize   = 10000
        newlist     = parMapChunked rseq chunkSize g [0..length]
        sum         = foldl' (+) 0 newlist
    print sum
