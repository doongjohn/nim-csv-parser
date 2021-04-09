import ../types
import ../states


template transitionToNotContent =
  if prevState == stateContent:
    csvObj.push(source[contentRange])


template transitionToContent =
  if prevState != stateContent:
    contentRange.a = pos


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of ' ':
    discard
  of '\n':
    transitionToNotContent()
    return stateNewLine
  of ',':
    transitionToNotContent()
    return stateDelimiter
  of '\"':
    return stateDoubleQuotes
  else:
    transitionToContent()
    return stateContent
  inc pos


proc newStateWhitespace*: State =
  newState(
    onUpdate = onUpdate,
  )

