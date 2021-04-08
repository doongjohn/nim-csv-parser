import ../types
import ../states
import ../utils


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ':
    return stateWhitespace
  of ',':
    if source.at(pos - 1) == ',':
      csvObj.push("")
  of '\n':
    return stateNewLine
  else:
    return stateContent
  inc pos


proc newStateDelimiter*: State =
  newState(
    onUpdate = onUpdate,
  )
