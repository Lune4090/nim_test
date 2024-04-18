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

### nimで最低限の科学計算環境を整える為に必要なパッケージ

Standard libraries ("std/"は必須ではない)
- std/random
- std/math
- std/stats
- std/sequtils : これがないとmapとかのまともな配列操作ができない　

Plotting
- plotly : pythonのplotlyに近い、Seqを入力としてTraceを作成、Layoutを定義後TraceとLayoutからPlotを作成、show()で即時描画
- chroma : 色指定、必須ではない

Data analysis
- arraymancer : juliaに比べると限定的だがブロードキャストが可能
- datamancer

## examples

### 単純なガウシアンプロット

```nim

import std/random
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
