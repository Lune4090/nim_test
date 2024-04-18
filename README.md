# nim/nimble overview

## nimble

### nim c <name.nim> と nimble buildの違い

nim c <> 対象のソースコードをコンパイルするコマンド
パッケージのアドレスが分かっているならそれらは無制限に使用できる

一方、nimble buildはnimble initがそうであったように、ディレクトリ内を一つのプロジェクトとしてみている。
だから、ソースコード内にインストール済みのライブラリがあってもいぞんかん

## packages

### nimで最低限の科学計算環境を整える為に必要なパッケージ

std/random
std/math
stats
sequtils

plotly
chroma

arraymancer

datamancer

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
