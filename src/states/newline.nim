import ../types
import ../states
import ../utils


proc onExit(source: string, pos: var int, csvObj: var CSVObject) =
  if source.at(pos + 1) notin ['\0', '\n']:
    csvObj.addColumn()


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ', '\n':
    discard
  of ',':
    return stateDelimiter
  of '\"':
    return stateDoubleQuotes
  else:
    return stateContent
  inc pos


proc newStateNewline*: State =
  newState(
    onExit = onExit,
    onUpdate = onUpdate,
  )

