import unittest

import currying

suite "curring":

  test "simple function":
    proc f(x, y: int): int {.curried.} = x + y
    check(f(1)(2) == f(1, 2))
    check(f(1)(2) == 3)
    var f1 = f 2
    check(f1(3) == 5)

  test "generic function":
    proc f[T](x, y: T): T {.curried.} = x + y

    var fi = f 2
    check(fi(6) == 8)

    var ff = f 10.01
    check(ff(1000.0) == 1010.01)