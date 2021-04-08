import ../types
import ../states


proc onEnter(source: string, pos: var int, csvObj: var CSVObject) =
  if pos != source.high:
    csvObj.addColumn()


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ':
    return stateWhitespace
  of ',':
    return stateDelimiter
  of '\n':
    discard
  else:
    return stateContent
  inc pos


proc newStateNewline*: State =
  newState(
    onEnter = onEnter,
    onUpdate = onUpdate,
  )
