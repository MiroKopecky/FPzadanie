# FPzadanie

## package
### app (should preferably contain only files related to executables)
contains main .hs file
### src
contains lib .hs file

## importing libs
If you need to include another library (for example the package [text](https://hackage.haskell.org/package/text)):

Add the package text to the file package.yaml in the section dependencies: ....

Run **stack build** another time.
stack build will update my-project.cabal for you. If desired you can update the .cabal file manually and stack will use .cabal instead of package.yaml.

If you get an error that tells you your package isn't in the LTS. Just try to add a new version in the stack.yaml file in the extra-deps section.

## 1. install stack

**WINDOWS:**
https://get.haskellstack.org/stable/windows-x86_64-installer.exe

**LINUX:**
curl -sSL https://get.haskellstack.org/ | sh
**OR**
wget -qO- https://get.haskellstack.org/ | sh

## 2. running code
from terminal:

1. stack build (run this command after every change)
2. stack exec FPzadanie-exe*

*first time running this command will install GHC (~460MB)

