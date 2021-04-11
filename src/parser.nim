import types
import states


proc parse*(source: string): CSVObject =
  var
    csvObj = newCSVObject()
    pos = 0

  runState(source, pos, csvObj)
  return csvObj

