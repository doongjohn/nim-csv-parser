import types
import utils


# state type
type
  ProcEnterExit = proc(source: string, pos: var int, csvObj: var CSVObject)
  ProcUpdate = proc(source: string, pos: var int, csvObj: var CSVObject): State

  State* = ref object
    onEnter*: ProcEnterExit
    onExit*: ProcEnterExit
    onUpdate*: ProcUpdate


proc newState*(
    onEnter: ProcEnterExit = (proc(source: string, pos: var int, csvObj: var CSVObject) = discard),
    onExit: ProcEnterExit = (proc(source: string, pos: var int, csvObj: var CSVObject) = discard),
    onUpdate: ProcUpdate = (proc(source: string, pos: var int, csvObj: var CSVObject): State = discard)
  ): State =
  State(
    onEnter: onEnter,
    onExit: onExit,
    onUpdate: onUpdate,
  )


# state data
var curState*: State
var prevState*: State
var contentRange* = 0 .. 0

importState(
  states/content,
  states/doublequotes,
  states/delimiter,
  states/newline,
  states/whitespace,
  states/sof,
  states/eof,
)


# state functions
proc initState*(source: string, pos: var int, csvObj: var CSVObject) =
  curState = stateSof
  prevState = stateSof
  curState.onEnter(source, pos, csvObj)


proc runState*(source: string, pos: var int, csvObj: var CSVObject) =
  while pos < source.len:
    let nextState = curState.onUpdate(source, pos, csvObj)
    if nextState == stateEof:
      return
    if nextState == nil or curState == nextState:
      continue
    (prevState, curState) = (curState, nextState)
    prevState.onExit(source, pos, csvObj)
    curState.onEnter(source, pos, csvObj)


proc endState*(source: string, pos: var int, csvObj: var CSVObject) =
  (prevState, curState) = (curState, stateEof)
  prevState.onExit(source, pos, csvObj)
  curState.onEnter(source, pos, csvObj)

