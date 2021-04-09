# TODO
# - parse "" correctly
# - do stuff better


import types
import parser


proc main =
  # stdout.write "csv file path: "
  # let filepath = stdin.readLine()
  # let source = readFile filepath
  let source = readFile "./csv-example.csv"
  let csvObj = parse source
  
  # print csv data
  for column in csvObj.data:
    echo column


main()
