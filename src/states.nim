import types


# state type
type State* = ref object
  onPreEnter*: proc(source: string, pos: var int, nextState: State, csvObj: var CSVObject)
  onPreExit*: proc(source: string, pos: var int, nextState: State, csvObj: var CSVObject)
  onEnter*: proc(source: string, pos: var int, csvObj: var CSVObject)
  onExit*: proc(source: string, pos: var int, csvObj: var CSVObject)
  onUpdate*: proc(source: string, pos: var int, csvObj: var CSVObject): State

proc newState*(
    onPreEnter: proc(source: string, pos: var int, nextState: State, csvObj: var CSVObject) =
      (proc(source: string, pos: var int, nextState: State, csvObj: var CSVObject) = discard),
    onPreExit: proc(source: string, pos: var int, nextState: State, csvObj: var CSVObject) =
      (proc(source: string, pos: var int, nextState: State, csvObj: var CSVObject) = discard),
    onEnter: proc(source: string, pos: var int, csvObj: var CSVObject) =
      (proc(source: string, pos: var int, csvObj: var CSVObject) = discard),
    onExit: proc(source: string, pos: var int, csvObj: var CSVObject) =
      (proc(source: string, pos: var int, csvObj: var CSVObject) = discard),
    onUpdate: proc(source: string, pos: var int, csvObj: var CSVObject): State =
      (proc(source: string, pos: var int, csvObj: var CSVObject): State = discard)
  ): State =
  State(
    onPreEnter: onPreEnter,
    onPreExit: onPreExit,
    onEnter: onEnter,
    onExit: onExit,
    onUpdate: onUpdate,
  )


# state data
var curState*: State
var prevState*: State
var contentRange* = 0 .. 0


# import states
var 
  stateContent*: State
  stateDelimiter*: State
  stateNewline*: State
  stateWhitespace*: State
  stateEof*: State

import states/content
stateContent = newStateContent()

import states/delimiter
stateDelimiter = newStateDelimiter()

import states/newline
stateNewline = newStateNewline()

import states/whitespace
stateWhitespace = newStateWhitespace()

import states/eof
stateEof = newStateEof()


# state functions
proc initState*(startState: State, source: string, pos: var int, csvObj: var CSVObject) =
  curState = startState
  prevState = startState
  curState.onEnter(source, pos, csvObj)


proc runState*(source: string, pos: var int, csvObj: var CSVObject) =
  let nextState = curState.onUpdate(source, pos, csvObj)
  if nextState == nil or curState == nextState:
    return
  curState.onPreExit(source, pos, nextState, csvObj)
  nextState.onPreEnter(source, pos, nextState, csvObj)
  (prevState, curState) = (curState, nextState)
  prevState.onExit(source, pos, csvObj)
  curState.onEnter(source, pos, csvObj)


proc finishState*(source: string, pos: var int, csvObj: var CSVObject) =
  curState.onPreExit(source, pos, stateEof, csvObj)
  stateEof.onPreEnter(source, pos, stateEof, csvObj)
  (prevState, curState) = (curState, stateEof)
  prevState.onExit(source, pos, csvObj)
  curState.onEnter(source, pos, csvObj)
