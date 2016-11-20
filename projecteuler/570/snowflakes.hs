import Control.Parallel
import Control.Parallel.Strategies
import Control.Exception
import Data.Time.Clock
import Text.Printf
import System.Environment
import Control.DeepSeq


blue :: Integer -> Integer
blue n = 6*(2*4^n - 3^n)

yellow :: Integer -> Integer
yellow n = 6*(4^n*(3*n - 17) + 3^n*(2*n + 17))

--
-- $ ghci snowflakes.hs
-- Prelude> s(500)
--
s :: Integer -> Integer
s n = sum (zipWith gcd (map blue [0..n]) (map yellow [0..n]))

--
-- $ ghc snowflakes.hs -O2 -threaded -rtsopts
-- $ ./snowflakes +RTS -N4 -s
--
pres n = do
    a <- rpar (force (map blue [0..n]))
    b <- rpar (force (map yellow [0..n]))
    rseq a
    rseq b
    g <- rpar (zipWith gcd a b)
    rseq g
    s <- rpar (sum g)
    rseq s
    return (s)

printTimeSince t0 = do
  t1 <- getCurrentTime
  printf "time: %.2fs\n" (realToFrac (diffUTCTime t1 t0) :: Double)

main = do
    t0 <- getCurrentTime
    r <- evaluate (runEval $ pres (10000000))
    printTimeSince t0
    print r
