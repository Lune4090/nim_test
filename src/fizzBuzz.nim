import results

export results

type
  EnumErr = enum
    ValErr

type ResSeqStr = Result[seq[string], EnumErr]

func fizzBuzzitr*(min: int, max:int): ResSeqStr = 
  if min < max:

    var target = min
    var res = newSeq[string]()
    while target <= max:
      if target mod 15 == 0: res.add("FizzBuzz")
      elif target mod 3 == 0: res.add("Fizz")
      elif target mod 5 == 0: res.add("Fizz")
      else: res.add($target)
      inc (target)

    return ok(res)

  else:
    return err(EnumErr.ValErr)

# for word in fizzBuzzitr(0, 100):
#   echo word

