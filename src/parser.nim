import types
import states


proc parse*(source: string): CSVObject =
  var csvObj = newCSVObject()
  var pos = 0
  initState(stateWhiteSpace, source, pos, csvObj)
  while pos < source.len:
    runState(source, pos, csvObj)
  finishState(source, pos, csvObj)
  return csvObj
