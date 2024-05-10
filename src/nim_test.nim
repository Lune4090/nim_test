when isMainModule:
  echo("Hello, World! from MainModule.")

import ./fizzBuzz as fb
import ../examples/plot/scatter as sc
import ../examples/plot/histogram as hs
import ../examples/plot/contour as co
import ../examples/plot/heatmap as hm

echo fb.fizzBuzzitr(0, 100)
echo fb.fizzBuzzitr(100, 0)
