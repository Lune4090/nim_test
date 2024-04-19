import plotly

proc draw_contour*() = 
  let
    d = Trace[float](`type`: PlotType.Contour) # backtick (`) is used to pass the identifier which is registered as keyword in Nim language.

  d.xs = @[-2.0, -1.5, -1.0, 0.0, 1.0, 1.5, 2.0, 2.5]
  d.ys = @[0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6]
  d.zs = @[@[2, 4, 7, 12, 13, 14, 15, 16],
         @[3, 1, 6, 11, 12, 13, 16, 17],
         @[4, 2, 7, 7, 11, 14, 17, 18],
         @[5, 3, 8, 8, 13, 15, 18, 19],
         @[7, 4, 10, 9, 16, 18, 20, 19],
         @[9, 10, 5, 27, 23, 21, 21, 21],
         @[11, 14, 17, 26, 25, 24, 23, 22]]

  d.colorscale = ColorMap.Jet
  d.heatmap = true # smooth colors

  let
    layout = Layout(title: "Contour", 
                    width: 600, 
                    height: 600, 
                    yaxis: Axis(title: "x-ax"),
                    xaxis: Axis(title: "y-ax"),
                    autosize: false)

    p = Plot[float](layout: layout, traces: @[d])

  p.show()
