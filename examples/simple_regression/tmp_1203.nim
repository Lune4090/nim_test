import sequtils, sugar, datamancer, numericalnim
import arraymancer except read_csv

let
  data = readCsv("california_data.csv")
  target = readCsv("california_target.csv")

proc f0(a: float, b: float, x: float): float = a + b * x

proc fitFunc(params: Tensor[float], x: float): float =
  let
    a = params[0]
    b = params[1]
  result = f0(a, b, x)

let
  initialGuess = ones[float](2)
  data_medinc = data["MedInc"].toTensor(float)
  target_medhouseval = target["MedHouseValue"].toTensor(float)
  solution = levmarq(fitFunc, initialGuess, data_medinc, target_medhouseval)

echo "parameters: " & $solution

echo "predict(x=5): " & $f0(solution[0], solution[1], 5)
echo "predict(x=10): " & $f0(solution[0], solution[1], 10)
echo "predict(x=15): " & $f0(solution[0], solution[1], 15)


import plotly, chroma

proc draw_scatter*() = 
  var
    color1 = @[Color(r:0.9, g:0.4, b:0.0, a: 1.0)]
    color2 = @[Color(r:0.2, g:0.5, b:0.1, a: 1.0)]

    d1 = Trace[float](mode: PlotMode.Lines, `type`: PlotType.Scatter)
    d2 = Trace[float](mode: PlotMode.Markers, `type`: PlotType.Scatter)
    size = @[16.float]

  d1.marker =Marker[float](size:size, color: color1)
  d1.xs = linspace(min(data_medinc), max(data_medinc), 100)
  d1.ys = d1.xs.map(x => f0(solution[0], solution[1], x))
  d1.text = @["hello", "data-point", "third", "highest", "<b>bold</b>"]

  d2.marker =Marker[float](color: color2)
  d2.xs = data_medinc.toSeq1D
  d2.ys = target_medhouseval.toSeq1D
  d2.text = @["hello", "data-point", "third", "highest", "<b>bold</b>"]

  var
    layout = Layout(title: "testing", width: 1200, height: 400,
                      xaxis: Axis(title:"medinc"),
                      yaxis:Axis(title: "medhouseval"), autosize:false)
    p = Plot[float](layout:layout, traces: @[d1, d2])

  echo "figure drawing..."
  p.show()

draw_scatter()
