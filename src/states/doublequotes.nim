import std/strutils
import ../types
import ../states
import ../utils


template onDoubleQuotesFound =
  if source.at(pos + 1) == '\"':
    # escape doublequotes
    inc pos
  else:
    # push content
    contentRange.b = pos - 1
    csvObj.push(source[contentRange].replace("\"\"", "\""))
    # next state
    inc pos, 2
    return if pos > source.high: stateEof else: stateWhitespace
  

proc onEnter(source: string, pos: var int, csvObj: var CSVObject) =
  inc pos
  contentRange.a = pos


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of '\"':
    onDoubleQuotesFound()
  else:
    discard
  inc pos


proc newStateDoubleQuotes*: State =
  newState(
    onEnter = onEnter,
    onUpdate = onUpdate,
  )

