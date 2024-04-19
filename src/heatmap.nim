import plotly
import random
import sequtils

proc draw_heatmap*() = 
  let
    d = Trace[float](mode: PlotMode.Lines, `type`: PlotType.HeatMap) # backtick (`) is used to pass the identifier which is registered as keyword in Nim language.

  d.colormap = ColorMap.Viridis

  d.zs = newSeqWith(28, newSeq[float](28))

  for x in 0 ..< 28:
    for y in 0 ..< 28:
      d.zs[x][y] = rand(1.0)


  let
    layout = Layout(title: "heatmap", 
                    width: 600, 
                    height: 600, 
                    yaxis: Axis(title: "x-ax"),
                    xaxis: Axis(title: "y-ax"),
                    barmode: BarMode.Stack,
                    autosize: false)

    p = Plot[float](layout: layout, traces: @[d])
  p.show()
