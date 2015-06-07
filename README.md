Glob matching in Haskell.

Relevant links
--------------

This is an attempt at doing this assignment: <http://www.scs.stanford.edu/14sp-cs240h/labs/lab1.html>

Applicative parsers: <http://www.seas.upenn.edu/~cis194/spring13/hw/10-applicative.pdf>

Building and testing
--------------------

In the `globber-1.0.0` directory:

```
cabal sandbox init
cabal install --only-dependencies --enable-tests
cabal configure --enable-tests
cabal build
```

`cabal test` to run the tests.

