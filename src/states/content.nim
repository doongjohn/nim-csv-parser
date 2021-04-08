import ../types
import ../states


proc onPreExit(source: string, pos: var int, nextState: State, csvObj: var CSVObject) =
  contentRange.b = pos - 1


proc onEnter(source: string, pos: var int, csvObj: var CSVObject) =
  if prevState in [stateDelimiter, stateNewLine]:
    contentRange.a = pos


proc onExit(source: string, pos: var int, csvObj: var CSVObject) =
  if curState != stateWhitespace:
    csvObj.push(source[contentRange])


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ':
    return stateWhitespace
  of ',':
    return stateDelimiter
  of '\n':
    return stateNewLine
  else:
    discard
  inc pos


proc newStateContent*: State =
  newState(
    onPreExit = onPreExit,
    onEnter = onEnter,
    onExit = onExit,
    onUpdate = onUpdate,
  )
