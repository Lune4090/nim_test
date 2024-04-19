when isMainModule:
  echo("Hello, World! from MainModule.")

import ./fizzBuzz as fb
import ./scatter as sc
import ./histogram as hs
import ./contour as co
import ./heatmap as hm

for word in fb.fizzBuzzitr(0, 100):
  echo word

sc.draw_scatter()
hs.draw_histogram()
co.draw_contour()
hm.draw_heatmap()

# var seed = initRand(0)
# var a = gauss(seed)
# echo a
# var b = a
# echo a
# echo b

