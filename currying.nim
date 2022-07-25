import macros, sugar, sequtils

proc typedParams(params: NimNode): seq[NimNode] {.compileTime.} =
  ## (a, b: int, c: float)
  ## -> (a: int, b: int, c: float)
  params.expectKind nnkFormalParams
  result = newSeq[NimNode]()
  for param in params:
    case param.kind
    of nnkIdentDefs:
      let identType = param[param.len-2]
      for i in 0..<param.len-2:
        result.add(newIdentDefs(param[i], identType))
    else:
      result.add(param)

macro curried*(f: untyped): auto =
  result = newStmtList()

  var
    genericParams = f[2]
    originalParams = typedParams(f.params())
  
  result.add(newNimNode(nnkProcDef).add(
    f.name().copy(),
    newEmptyNode(),
    genericParams.copy(),
    newNimNode(nnkFormalParams).add(
      map(originalParams, param => param.copy())
    ),
    newEmptyNode(),
    newEmptyNode(),
    f.body().copy()))

  var baseParams = originalParams
  baseParams[0] = newIdentNode("auto")

  for i in countdown(baseParams.len-1, 2):
    result.add(newNimNode(nnkProcDef).add(
      f.name().copy(),
      newEmptyNode(),
      genericParams.copy(),
      newNimNode(nnkFormalParams).add(
        map(baseParams[0..i-1], param => param.copy())
      ),
      newEmptyNode(),
      newEmptyNode(),
      newStmtList(
        newProc(
          params=[baseParams[0], baseParams[i]],
          body=newStmtList(
            newCall(
              f.name().copy(),
              map(baseParams[1..i], param => param[0].copy())
            )
          ),
          procType=nnkLambda
        )
      )
    ))