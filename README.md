# Currying Library for Nim

## Usage

```nim
import currying

proc f(x, y: A): A {.curried.} =
	...
```

## Example

```nim
import currying

proc sum(x, y: int): int {.curried.} = x + y

var sum10 = sum 10
echo sum10 20
# 20
```

```nim
import currying, sequtils

type
  Int = distinct int

converter toInt(x: int): Int = Int(x)

proc `$`(x: Int): string = $x.int

proc `*`(x, y: Int): Int {.curried.} =
  x.int * y.int

var data = map(@[1, 2, 3, 4, 5], toInt)
echo map(data, (* 2))
# @[2, 4, 6, 8, 10]
```

