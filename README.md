# nim/nimble overview

## nimble

### nim c <name.nim> と nimble buildの違い

nim c <> : 対象のソースコードをコンパイルするコマンド
- nim.cfgを参照するみたい
- パッケージのアドレスが分かっているならそれらは無制限に使用できる

nimble build : プロジェクトをビルドするコマンド
- <project name>.nimbleを参照する
- nimble initがそうであったように、ディレクトリ内を一つのプロジェクトとしてみている。
- だから、ソースコード内にインストール済みのライブラリがあっても依存関係として記載されていないなら、buildできない、ということになる。

## packages

### nimで生きていくのに必要なパッケージ

Standard libraries ("std/"で始まるが必須ではない)
- random
- math
- stats
- sequtils  : これがないとmapとかのまともな配列操作ができない　
- os        : pythonのosに相当, "eza -a".execShellCmdとか"WriteFile("tmp.csv")"できる！
- terminal  : progress bar描ける
- sugar     : (x, y) => x+yとかdump(expr出力)とかできる

Plotting
- nim-plotly (plotly) : pythonのplotlyに近い、Seqを入力としてTraceを作成、Layoutを定義後TraceとLayoutからPlotを作成、show()で即時描画
- chroma : 色指定、必須ではない

Data analysis
- arraymancer : seq.toTensor.reshapeでTensor作成。juliaに比べると限定的だがブロードキャストが可能、ニューラルネットワーク用のツールも集約
- datamancer : col-indexのdataframe(seq)

Game
- naylib (raylib) : raylib(backend: OpenGL4.3)のwrapper, 2D,3D共に動作確認済み

Science
- Unchained : compile-time unit check, 10.kg + 5.lbsみたいな記法ができる
- NumericalNim : Vector(Seqではない), Opt, Fit, Interpolat, 更にlinspaceまで！

Threading
- weave : message-passing basedなマルチスレッディングランタイム。raytracingのデモもある

TextEditor
- moe : Vim-likeテキストエディタ。日本人の方が主軸になって頑張ってる

2Dgraphics
- pixie : Cairoとかと同じ汎用2Dグラフィックスライブラリ

GUI
- nimx : SDL2(OpenGL)-based GUI library, nimble installからbuild一発でGUIアプリができる

CLI
- cligen : dispatchした関数とファイルを同名にしてコンパイルするだけでCLIアプリができる

Web
nim-basolato



## examples

### 単純なガウシアンプロット

```nim

import random
import stats
import plotly
import sequtils

var seed = initRand(0)
var seed2 = initRand(1)

var x = newSeq[float](100)
var y = newSeq[float](100)

x = x.map(proc(x: float): float = gauss(seed))
y = y.map(proc(x: float): float = gauss(seed2))

var dd = Trace[float](mode: PlotMode.Markers, `type`: PlotType.Scatter)

dd.xs = x
dd.ys = y

var p = Plot[float](traces: @[dd])
p.show()

```
### nimでhttp request

```nim

import httpclient
let cl = newHttpClient()

try:
  echo client.getContent("https://drive.google.com/uc?id=1SrmPUcMLX5mnyNsaa2E9RMOkVLUkzzzG")
finally:
  client.close()

# Do NOT forget to add -d:ssl option to enable ssl encryption when you compile the code !!!
  
```
