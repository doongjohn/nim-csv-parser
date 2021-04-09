import types
import states


proc parse*(source: string): CSVObject =
  var
    csvObj = newCSVObject()
    pos = 0

  initState(source, pos, csvObj)
  runState(source, pos, csvObj)
  endState(source, pos, csvObj)

  return csvObj
