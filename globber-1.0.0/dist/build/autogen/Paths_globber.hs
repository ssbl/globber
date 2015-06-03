module Paths_globber (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/shubham/prog/hs/globber-1.0.0/.cabal-sandbox/bin"
libdir     = "/home/shubham/prog/hs/globber-1.0.0/.cabal-sandbox/lib/x86_64-linux-ghc-7.6.3/globber-1.0.0"
datadir    = "/home/shubham/prog/hs/globber-1.0.0/.cabal-sandbox/share/x86_64-linux-ghc-7.6.3/globber-1.0.0"
libexecdir = "/home/shubham/prog/hs/globber-1.0.0/.cabal-sandbox/libexec"
sysconfdir = "/home/shubham/prog/hs/globber-1.0.0/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "globber_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "globber_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "globber_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "globber_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "globber_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
