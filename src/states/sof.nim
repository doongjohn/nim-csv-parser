import ../types
import ../states


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ', '\n':
    discard
  of ',':
    return stateDelimiter
  of '\"':
    return stateDoubleQuotes
  else:
    contentRange.a = pos
    return stateContent
  inc pos


proc newStateSof*: State =
  newState(
    onUpdate = onUpdate,
  )

