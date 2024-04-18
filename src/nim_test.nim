when isMainModule:
  echo("Hello, World! from MainModule.")

import ./fizzBuzz as fb
import ./scatter as sc
import ./histogram as hs

for word in fb.fizzBuzzitr(0, 100):
  echo word

sc.draw_scatter()
hs.draw_histogram()

# var seed = initRand(0)
# var a = gauss(seed)
# echo a
# var b = a
# echo a
# echo b

