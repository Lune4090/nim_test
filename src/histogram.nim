import plotly
import std/random

proc draw_histogram*() = 
  let
    d1 = Trace[int](`type`: PlotType.Histogram, opacity: 0.8, name: "some values") # backtick (`) is used to pass the identifier which is registered as keyword in Nim language.
    d2 = Trace[int](`type`: PlotType.Histogram, opacity: 0.8, name: "other staff")

  d1.ys = newSeq[int](200)
  d2.ys = newSeq[int](200)

  for i, x in d1.ys:
    d1.ys[i] = rand(20)
    d2.ys[i] = rand(20)

  for i in 0..40:
    d1.ys[i] = 12

  let
    layout2 = Layout(title: "stacked histogram", 
                    width: 1200, 
                    height: 400, 
                    yaxis: Axis(title: "values"),
                    xaxis: Axis(title: "count"),
                    barmode: BarMode.Stack,
                    autosize: false)

    p = Plot[int](layout: layout2, traces: @[d1, d2])

  p.show()
