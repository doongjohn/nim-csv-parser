
type CSVObject* = ref object
  data*: seq[seq[string]]


proc newCSVObject*: CSVObject =
  CSVObject(data: @[newSeq[string]()])


proc add*(self: var CSVObject, column: int, value: string) =
  self.data[column] &= value


proc push*(self: var CSVObject, value: string) =
  self.data[^1] &= value


proc addColumn*(self: var CSVObject) =
  self.data &= newSeq[string]()
