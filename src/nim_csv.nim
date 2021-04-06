{.experimental: "codeReordering".}


type CSVObject = object
  data: seq[seq[string]]


proc addColumn(self: var CSVObject) =
  self.data.add newSeq[string]()


proc addRow(self: var CSVObject, column: int, str: string) =
  self.data[column].add str


type
  ParseState = ref object of RootObj
  ParseStateEmpty = ref object of ParseState
  ParseStateContent = ref object of ParseState
  ParseStateDelimiter = ref object of ParseState
  ParseStateNewLine = ref object of ParseState

let
  stateEmpty = ParseStateEmpty()
  stateContent = ParseStateContent()
  stateDelimiter = ParseStateDelimiter()
  stateNewLine = ParseStateNewLine()


const delimiter = ','
  
var 
  source = ""
  csvObj = CSVObject(data: @[newSeq[string]()])
  curState: ParseState = stateEmpty
  prevState: ParseState = stateEmpty
  contentRange = 0 .. 0

template lineNum: int = csvObj.data.high


method statePreEnter(state: ParseState, c: char, i: var int) {.base.} = discard
method statePreExit(state: ParseState, c: char, i: var int) {.base.} = discard
method stateEnter(state: ParseState, c: char, i: var int) {.base.} = discard
method stateExit(state: ParseState, c: char, i: var int) {.base.} = discard
method stateUpdate(state: ParseState, c: char, i: var int) {.base.} = discard


method stateUpdate(state: ParseStateEmpty, c: char, i: var int) =
  case c
  of ' ':
    discard
  of delimiter:
    if prevState == stateContent:
      csvObj.addRow(lineNum, source[contentRange])
    changeState stateDelimiter, c, i
    return
  of '\n':
    if prevState == stateContent:
      csvObj.addRow(lineNum, source[contentRange])
    changeState stateNewLine, c, i
    return
  else:
    if prevState != stateContent:
      contentRange.a = i
    changeState stateContent, c, i
    return
  inc i


method statePreExit(state: ParseStateContent, c: char, i: var int) =
  contentRange.b = i - 1

method stateExit(state: ParseStateContent, c: char, i: var int) =
  if curState != stateEmpty:
    csvObj.addRow(lineNum, source[contentRange])

method stateUpdate(state: ParseStateContent, c: char, i: var int) =
  case c
  of ' ':
    changeState stateEmpty, c, i
    return
  of delimiter:
    changeState stateDelimiter, c, i
    return
  of '\n':
    changeState stateNewLine, c, i
    return
  else:
    discard
  inc i


method stateExit(state: ParseStateDelimiter, c: char, i: var int) =
  contentRange.a = i

method stateUpdate(state: ParseStateDelimiter, c: char, i: var int) =
  case c
  of delimiter:
    discard
  of ' ':
    changeState stateEmpty, c, i
    return
  of '\n':
    changeState stateNewLine, c, i
    return
  else:
    changeState stateContent, c, i
    return
  inc i


method stateEnter(state: ParseStateNewLine, c: char, i: var int) =
  if i != source.high:
    csvObj.addColumn()

method stateExit(state: ParseStateNewLine, c: char, i: var int) =
  contentRange.a = i

method stateUpdate(state: ParseStateNewLine, c: char, i: var int) =
  case c
  of '\n':
    discard
  of ' ':
    changeState stateEmpty, c, i
    return
  of delimiter:
    changeState stateDelimiter, c, i
    return
  else:
    changeState stateContent, c, i
    return
  inc i


proc changeState(nextState: ParseState, c: char, i: var int) =
  if curState == nil or curState == nextState: return
  statePreExit curState, c, i
  statePreEnter nextState, c, i
  (prevState, curState) = (curState, nextState)
  stateExit prevState, c, i
  stateEnter nextState, c, i


proc parseCsv(source: string) =
  var i = 0
  while i < source.len:
    curState.stateUpdate(source[i], i)


proc main =
  source = readFile "./file.csv"
  source.parseCsv()
  echo csvObj


main()
