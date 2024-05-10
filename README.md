# nim/nimble overview

## 感想

### 20240420 (Update: 0510)

Clever Cとでも言うべき言語.

個人的に必要かつ今まで触れてきた言語(python, julia, c++, rust)で得られなかった

- ミニマルかつ高速なバイナリを吐ける静的コンパイル
- 後から見返し易い記述の簡潔さと自然さ
- 各種関数, ASTいじれるマクロや各種ライブラリなどの拡張性

の両立をしているのでこれからの主軸にしたい.

ただキラーアプリっぽいものが思いつかないからまだ知名度が低い状態は続きそう

## Websites

### [Nim Tutorial](https://nim-lang.org/docs/tut1.html)

一通り目を通したが、覚えきれてないので適宜参照

### [SciNim](https://scinim.github.io/getting-started/)

とりあえず一通りの科学計算周りの話はある

### [nimble dir](https://nimble.directory/)

v2.0.2現在でデファクトになっているパッケージマネジャーnimbleに登録されたパッケージ一覧

### [Nim Manual](https://nim-lang.org/docs/manual.html)

## Packages

### Essensial

- Standard libraries ("std/"で始まるが必須ではない)
  - [**random**](https://nim-lang.org/docs/random.html)
  - [**math**](https://nim-lang.org/docs/math.html)
    - これがないと累乗もできない
  - [**stats**](https://nim-lang.org/1.2.0/stats.html)
  - [**sequtils**](https://nim-lang.org/docs/sequtils.html)
    - これがないとmapとかのまともな配列操作ができない　
  - [**os**](https://nim-lang.org/docs/os.html)
    - pythonのosに相当, "eza -a".execShellCmdとか"WriteFile("tmp.csv")"できる！
  - [**sugar**](https://nim-lang.org/docs/sugar.html)
    - (x, y) => x+yとかdump(hoge)(AST出力)とかできる
  - [terminal](https://nim-lang.org/docs/terminal.html)
    - progress bar描ける

- Plotting
  - [**nim-plotly**](https://github.com/SciNim/nim-plotly/tree/master/examples)
    - libraryname: plotly
    - pythonのplotlyに近い、Seqを入力としてTraceを作成、Layoutを定義後TraceとLayoutからPlotを作成、show()で即時描画
  - [chroma](https://treeform.github.io/chroma/)
    - 色指定、必須ではない

- Data analysis
  - [**arraymancer**](https://github.com/mratsim/Arraymancer)
    - seq.toTensor.reshapeでTensor作成。juliaに比べると限定的だがブロードキャストが可能、ニューラルネットワーク用のツールも集約
  - [**datamancer**](https://scinim.github.io/Datamancer/datamancer.html)
    - col-indexのdataframe(seq)

- **Science**
  - [**Unchained**](https://github.com/SciNim/Unchained)
    - compile-time unit checker
    - 10.kg + 5.lbsみたいに記法付きの計算ができる
  - [**NumericalNim**](https://github.com/SciNim/numericalnim)
    - Vector(Seqではない), Opt, Fit, Interpolat, 更にlinspaceまで！
    - levmarq(fn, initGuess, x, y)で

- GUI
  - [**fidget**](https://github.com/treeform/fidget)
    - Figmaに影響されたミニマルなGUIフレームワーク
    - シンプルなので少しいじるのが大変だが、かなりいい感じの見た目にできる

- Result type
  - [**Results**](https://github.com/arnetheduck/nim-results)
    - NimでRustみたいなResult型を使える！

- Game
  - [naylib](https://github.com/planetis-m/naylib)
    - [examples](https://github.com/planetis-m/raylib-examples)
    - libraryname: raylib
    - raylib(backend: OpenGL4.3)のwrapper, 2D,3D共に動作確認済み
    - そもそもゲームフレームワークなのでまあGUIアプリも作れる
    - WebAssembly(via emscripten, using [this config file](https://github.com/planetis-m/raylib-examples/blob/main/core/basic_window_web.nims))やAndroid(need Android SDK and some setting)向けのCompileもできるので、後述のweb frameworkと組み合わせたりすればいい感じにリッチなWebApp作れるんじゃない、ひとまずやる気はないけど

- CLI
  - [cligen](https://github.com/c-blake/cligen)
    - dispatchした関数とファイルを同名にしてコンパイルするだけでprocのCLIアプリ化ができる

### Additional

- Python
  - nimpy
    - let (/ var) hoge = "***python library name***".pyImportでインストール済みのPythonライブラリを引っ張ってこれる
    - scikit-learnのファイルが欲しいとか、グラフ描画だけPython使いたいとかのときに使える
    - とりあえずnimで作ったseqをtoTensor経由でTensor化、Ndarray化してpyplot.show()できることは確認した
    - np.array(@[1, 2, 3])はPyObjectになってくれる(つまり、特別な関数を用いなくてもSeq → PyObjectはできる)が、PyObject → Seqはない
    - ただし上記はむしろ例外的で、Tensor to ndarray (toNdarray), ndarray to Tensor (toTensor)はできるし、toSeq1D経由でSeqには戻せる
    - 後、scikit-learnのサンプルファイルやtoNdarrayで作ったnumpyのndarrayはNumpyArray型というPyObjectとは別の型になる

- Threading
  - [weave](https://github.com/mratsim/weave)
    - message-passing basedなマルチスレッディングランタイム。raytracingのデモもある
    - 但しNim Manual上にstdライブラリのasyncdispatchを使う説明が多いから導入コストがある

- TextEditor
  - [moe](https://github.com/fox0430/moe)
    - Vim-likeテキストエディタ。日本人の方が主軸になって頑張ってる

- 2Dgraphics
  - [pixie](https://github.com/treeform/pixiebook)
    - Cairoとかと同じ汎用2Dグラフィックス作成ライブラリ

- Web
  - [nim-basolato](https://github.com/itsumura-h/nim-basolato?tab=readme-ov-file)
    - actix-web並の速度を誇るフルスタックwebフレームワーク、日本人の方が主軸になって開発してる

## Examples

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
### http request

```nim

import httpclient
let cl = newHttpClient()

try:
  echo client.getContent("https://drive.google.com/uc?id=1SrmPUcMLX5mnyNsaa2E9RMOkVLUkzzzG")
finally:
  client.close()

# Do NOT forget to add -d:ssl compile option to enable ssl encryption at compile time (include inim))
  
```

### std/stats <-> datamancer連携 (seq -> dataframe -> column -> tensor -> seq)

```nim

import sequtils, arraymancer, datamancer

var
  sq0 = @[1, 2, 3]
  sq1 = @[4.0, 2.5, 8.5]
  df  = toDF({"weight": sq0, "height": sq1})
  ts = df["weight", float]
  sq2 = ts.toSeq1D

```

### 線形重回帰(multiple regression)
```nim

import sequtils, datamancer
  
```

## tips

### nim c <name.nim> と nimble buildの違い

- nim c <> : 対象のソースコードをコンパイルするコマンド
  - nim.cfgを参照するみたい
  - パッケージのアドレスが分かっているならそれらは無制限に使用できる

- nimble build : プロジェクトをビルドするコマンド
  - <project name>.nimbleを参照する
  - nimble initがそうであったように、ディレクトリ内を一つのプロジェクトとしてみている。
  - だから、ソースコード内にインストール済みのライブラリがあっても依存関係として記載されていないなら、buildできない、ということになる。
