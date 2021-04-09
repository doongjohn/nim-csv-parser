import ../types
import ../states


proc onEnter(source: string, pos: var int, csvObj: var CSVObject) =
  if prevState in [stateDelimiter, stateNewLine]:
    contentRange.a = pos


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ':
    contentRange.b = pos - 1
    return stateWhitespace
  of ',':
    contentRange.b = pos - 1
    csvObj.push(source[contentRange])
    return stateDelimiter
  of '\n':
    contentRange.b = pos - 1
    csvObj.push(source[contentRange])
    return stateNewLine
  else:
    discard
  inc pos


proc newStateContent*: State =
  newState(
    onEnter = onEnter,
    onUpdate = onUpdate,
  )

