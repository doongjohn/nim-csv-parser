import std/strutils
import ../types
import ../states
import ../utils


var enterPos = 0


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
  enterPos = pos
  inc pos
  contentRange.a = pos


proc onUpdate(source: string, pos: var int, csvObj: var CSVObject): State =
  case source[pos]
  of '\"':
    onDoubleQuotesFound()
  else:
    # check error
    if pos == source.high:
      echo "unclosed double quotes at " & $enterPos
      # maybe abort here?
  inc pos


proc newStateDoubleQuotes*: State =
  newState(
    onEnter = onEnter,
    onUpdate = onUpdate,
  )

