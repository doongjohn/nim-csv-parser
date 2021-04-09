import std/macros


proc at*(str: string, index: int): char =
  if index in 0 .. str.high:
    str[index]
  else:
    '\0'


macro importState*(importPaths: varargs[untyped]): untyped =
  result = newStmtList()
  let varSection = newNimNode(nnkVarSection)
  let importStmt = newNimNode(nnkImportStmt)
  let newStateStmt = newStmtList()
  result.add(varSection)
  result.add(importStmt)
  result.add(newStateStmt)

  for i in 0 ..< importPaths.len:
    let importPath = importPaths[i]
    let stateIdent = "state" & importPath[2].repr
    varSection.add(
      newIdentDefs(
        ident(stateIdent).postfix("*"),
        ident("State")
      )
    )
    importStmt.add(importPath)
    newStateStmt.add(
      newNimNode(nnkAsgn).add(
        ident(stateIdent),
        newCall("new" & stateIdent)
      )
    )
