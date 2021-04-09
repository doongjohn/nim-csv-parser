# TODO
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
  echo "\n---"
  for column in csvObj.data:
    for i, row in column:
      stdout.write "["
      stdout.write row
      stdout.write "] "
    echo "\n---"


main()
