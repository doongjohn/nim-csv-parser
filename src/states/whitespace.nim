import ../types
import ../states


proc onPreExit(source: string, pos: var int, nextState: State, csvObj: var CSVObject) =
  if nextState in [stateDelimiter, stateNewLine]:
    if prevState == stateContent:
      csvObj.push(source[contentRange])
  elif prevState != stateContent:
    contentRange.a = pos


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ':
    discard
  of ',':
    return stateDelimiter
  of '\n':
    return stateNewLine
  else:
    return stateContent
  inc pos


proc newStateWhitespace*: State =
  newState(
    onPreExit = onPreExit,
    onUpdate = onUpdate,
  )
