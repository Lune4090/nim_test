iterator fizzBuzzitr*(min: int, max:int): string = 
  var target = min
  while target <= max:
    yield if target mod 15 == 0: "FizzBuzz"
      elif target mod 3 == 0: "Fizz"
      elif target mod 5 == 0: "Fizz"
      else: $target
    inc (target)

# for word in fizzBuzzitr(0, 100):
#   echo word

