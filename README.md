# Currying

This package is a simple currying library for Nim.

## Installing

```
$ nimble install currying
```

## Usage

If you want to declare a curried function,  all you need to do is mark it with the  `curried` pragma.

You can use this package as follow.

```nim
import currying

proc f(x, y: A): A {.curried.} =
	...
```

## Example

The following example is a simple usage with sum function.

```nim
import currying

proc sum(x, y: int): int {.curried.} = x + y

var sum10 = sum 10
echo sum10 20
# 30
```



`curried` pragma can be used with generic procedures.

```nim
import future

proc f[T](x, y: T): T {.curried.} = x + y

var fint = f 2
echo(fint(6)) # 8

var ffloat = f 10.01
echo(ffloat(1000.0)) # 1010.01

proc g[T0, T1](x: T0, y: T0 -> T1): T1 {.curried.} = y(x)
var g10 = g[int, string](10)
echo(g10((x: int) => $x)) # 10
```

There are other examples in `tests/tests.nim` file.

It can also be used with infix operators.