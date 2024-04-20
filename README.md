# nim/nimble overview

## Useful website

### [Nim Tutorial](https://nim-lang.org/docs/tut1.html)

一通り目を通したが、覚えきれてないので適宜参照

### [SciNim](https://scinim.github.io/getting-started/)

とりあえず一通りの科学計算周りの話はある

### [nimble dir](https://nimble.directory/)

v2.0.2現在でデファクトになっているパッケージマネジャーnimbleに登録されたパッケージ一覧

### [Nim Manual](https://nim-lang.org/docs/manual.html)

Nimのパッケージのマニュアルは非常に分かりづらいが、Nim本体のマニュアルは悪くない

## packages

### nimで生きていくのに必要なパッケージ

**Essensial**

- Standard libraries ("std/"で始まるが必須ではない)
  - [random](https://nim-lang.org/docs/random.html)
  - [math](https://nim-lang.org/docs/math.html)
    - これがないと累乗もできない
  - [stats](https://nim-lang.org/1.2.0/stats.html)
  - [sequtils](https://nim-lang.org/docs/sequtils.html)
    - これがないとmapとかのまともな配列操作ができない　
  - [os](https://nim-lang.org/docs/os.html)
    - pythonのosに相当, "eza -a".execShellCmdとか"WriteFile("tmp.csv")"できる！
  - [terminal](https://nim-lang.org/docs/terminal.html)
    - progress bar描ける
  - [sugar](https://nim-lang.org/docs/sugar.html)
    - (x, y) => x+yとかdump(expr出力)とかできる

- Plotting
  - [nim-plotly](https://github.com/SciNim/nim-plotly/tree/master/examples)
    - libraryname: plotly
    - pythonのplotlyに近い、Seqを入力としてTraceを作成、Layoutを定義後TraceとLayoutからPlotを作成、show()で即時描画
  - [chroma](https://treeform.github.io/chroma/)
    - 色指定、必須ではない

- Data analysis
  - [arraymancer](https://github.com/mratsim/Arraymancer) : seq.toTensor.reshapeでTensor作成。juliaに比べると限定的だがブロードキャストが可能、ニューラルネットワーク用のツールも集約
  - [datamancer](https://scinim.github.io/Datamancer/datamancer.html) : col-indexのdataframe(seq)

- Game/GUI
  - [naylib](https://github.com/planetis-m/naylib)
    - [examples](https://github.com/planetis-m/raylib-examples)
    - libraryname: raylib
    - raylib(backend: OpenGL4.3)のwrapper, 2D,3D共に動作確認済み
    - そもそもゲームフレームワークなのでまあGUIアプリも作れる
    - WebAssembly(via emscripten, using [this config file](https://github.com/planetis-m/raylib-examples/blob/main/core/basic_window_web.nims))やAndroid(need Android SDK and some setting)向けのCompileもできるので、後述のweb frameworkと組み合わせたりすればいい感じにリッチなWebApp作れるんじゃない、ひとまずやる気はないけど

- Science
  - [Unchained](https://github.com/SciNim/Unchained) : compile-time unit check, 10.kg + 5.lbsみたいな記法ができる
  - [NumericalNim](https://github.com/SciNim/numericalnim)
    - Vector(Seqではない), Opt, Fit, Interpolat, 更にlinspaceまで！

- 2Dgraphics
  - [pixie](https://github.com/treeform/pixiebook)
    - Cairoとかと同じ汎用2Dグラフィックスライブラリ

- CLI
  - [cligen](https://github.com/c-blake/cligen)
    - dispatchした関数とファイルを同名にしてコンパイルするだけでprocのCLIアプリ化ができる

**Additional**

- Threading
  - [weave](https://github.com/mratsim/weave)
    - message-passing basedなマルチスレッディングランタイム。raytracingのデモもある
    - 但しNim Manual上にstdライブラリのasyncdispatchを使う説明が多いから導入コストがある

- TextEditor
  - [moe](https://github.com/fox0430/moe)
    - Vim-likeテキストエディタ。日本人の方が主軸になって頑張ってる

- GUI
  - [nimx](https://github.com/yglukhov/nimx)
    - SDL2(OpenGL)-based GUI library, nimble installからbuild一発でGUIアプリができる
    - でもraylib, waふつーに動くからいらんくねって感じもする

- Web
  - [nim-basolato](https://github.com/itsumura-h/nim-basolato?tab=readme-ov-file)
    - actix-web並の速度を誇るフルスタックwebフレームワーク、日本人の方が主軸になって開発してる

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
## tips

### nim c <name.nim> と nimble buildの違い

nim c <> : 対象のソースコードをコンパイルするコマンド
- nim.cfgを参照するみたい
- パッケージのアドレスが分かっているならそれらは無制限に使用できる

nimble build : プロジェクトをビルドするコマンド
- <project name>.nimbleを参照する
- nimble initがそうであったように、ディレクトリ内を一つのプロジェクトとしてみている。
- だから、ソースコード内にインストール済みのライブラリがあっても依存関係として記載されていないなら、buildできない、ということになる。
