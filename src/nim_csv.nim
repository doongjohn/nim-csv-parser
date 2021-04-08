import types
import parser


proc main =
  let source = readFile "./csv-example.csv"
  let csvObj = parse source
  
  # print csv data
  for column in csvObj.data:
    echo column


main()
