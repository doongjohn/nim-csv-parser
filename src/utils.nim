
proc at*(str: string, index: int): char =
  if index in 0 .. str.high:
    str[index]
  else:
    '\0'
