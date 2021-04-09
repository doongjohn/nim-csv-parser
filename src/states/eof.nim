import ../types
import ../states


proc onEnter(source: string, pos: var int, csvObj: var CSVObject) =
  if contentRange.a <= contentRange.b and prevState == stateWhitespace:
    csvObj.push(source[contentRange])


proc newStateEof*: State =
  newState(
    onEnter = onEnter,
  )
