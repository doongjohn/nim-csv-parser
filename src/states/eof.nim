import ../types
import ../states


proc onEnter(source: string, pos: var int, csvObj: var CSVObject) =
  if prevState == stateWhitespace:
    csvObj.push(source[contentRange])


proc newStateEof*: State =
  newState(
    onEnter = onEnter,
  )
