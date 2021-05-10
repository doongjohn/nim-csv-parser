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
  states/sof,
  states/eof,
  states/content,
  states/doublequotes,
  states/delimiter,
  states/newline,
  states/whitespace,
)


# state function
proc runState*(source: string, pos: var int, csvObj: var CSVObject) =
  # state init
  curState = stateSof
  prevState = stateSof
  curState.onEnter(source, pos, csvObj)

  # state loop
  while pos < source.len:
    let nextState = curState.onUpdate(source, pos, csvObj)
    if nextState == stateEof:
      return
    if nextState == nil or curState == nextState:
      continue
    (prevState, curState) = (curState, nextState)
    prevState.onExit(source, pos, csvObj)
    curState.onEnter(source, pos, csvObj)

  # state end
  (prevState, curState) = (curState, stateEof)
  prevState.onExit(source, pos, csvObj)
  curState.onEnter(source, pos, csvObj)


