import unittest, future, sequtils

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

    proc g[T0, T1](x: T0, y: T0 -> T1): T1 {.curried.} = y(x)
    var gi2s = g[int, string](10)
    check(gi2s((x: int) => $x) == "10")

  test "binary operator":
    type
      Int = distinct int

    proc toInt(x: int): Int = Int(x)

    proc `*`(x, y: Int): Int {.curried.} =
      toInt(x.int * y.int)

    var
      x: Int = 2.toInt
      data = map(@[1, 2, 3, 4, 5], toInt)
      ans = @[2, 4, 6, 8, 10]
    for i, val in map(data, (* x)):
      check(val.int == ans[i])
