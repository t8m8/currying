import macros

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
    procName = f.name()
    procNameStr =
      if procName.kind in {nnkIdent, nnkAccQuoted}: $f.name()
      else: $f.name()[1]
    genericParams = f[2]
    params = typedParams(f.params())

  result.add(newNimNode(nnkProcDef).add(
    procName,
    newEmptyNode(),
    genericParams,
    newNimNode(nnkFormalParams).add(params),
    newEmptyNode(),
    newEmptyNode(),
    f.body()))

  params[0] = newIdentNode("auto")

  for i in countDown(params.len-1, 2):
    var callParams = newSeq[NimNode]()
    for param in params[1..i]:
      callParams.add(param[0])
    var
      innerBody = newStmtList(newCall(procNameStr, callParams))
      innerParams = newSeq[NimNode]()
    innerParams.add([newIdentNode("auto"), params[i]])
    var procBody = newStmtList(
      newProc(params=innerParams, body=innerBody, procType=nnkLambda))
    result.add(newNimNode(nnkProcDef).add(
      procName,
      newEmptyNode(),
      genericParams,
      newNimNode(nnkFormalParams).add(params[0..i-1]),
      newEmptyNode(),
      newEmptyNode(),
      procBody))
