#[
  方針
  1. Rust同様、CatchableErrorが生じる領域はResult[T, ref CatchableError]型を通して明示的に処理する
  - Uncatchableなエラー(SystemError系)はpanicさせても良いものとする
  2. 可能な限り副作用なしの領域を広げ, procよりfuncを優先して用いる. IO周りやCの関数との相互接続領域などの副作用が生じる部分は最小化する
  3. result型を用いなくてよいのはinim使用時のみであり、全ての場合においてresultsはmust-useとする
  4. その他、styleguideに従う

  System/exception
  - Exception
    - CatchableError
      - IOError
        - EOFError
      - ValueError
        - KeyError
      - OSError
        - LibraryError
    - Defect(UnCatchable)
      - ArithmeticDefect
      - AssertionDefect
      - DeadThreadDefect
      - NilAcccessDefect
      - FieldDefect
      - DivByZeroDefect
      - OverflowDefect
      - OutOfMemdefect
      - FloatingPointDefect
        - FloatInvalidOpDefect
        - FloatDivByZeroDefect
        - FloatOverflowDefect
        - FloatUnderflowDefect
      - IndexDefect
      - StackOverflowDefect (coroutine call overflow)
      - ObjectVonversionDefect
    - RootEffect
      - IOEffect
        - EOFEror
]# 


{. push raises: [] .}
import results, strutils

export results

func parseIntOriginal(x: string): Result[int, ref CatchableError] =
  try:
    let x_int = x.parseInt
    return ok(x_int)
  except:
    var e: ref CatchableError
    new(e)
    e.msg = "the request to the OS failed"
    return err(e)

func parseSeqIntOriginal(x: string): Result[seq[int], ref CatchableError] =
  try:
    let x_int = x.parseInt
    return ok(@[x_int])
  except:
    var
      e: ref CatchableError
    new(e)
    e.msg = "the request to the OS failed"
    return err(e)

func toSeq[T](x: Result[T, ref CatchableError]): Result[seq[T], ref CatchableError] =
  return ok(@[?x])

func tmpAdd(x: Result[int, ref CatchableError], y: int): Result[int, ref CatchableError] =
  ## ここで注目したいのが、この関数は明示的にエラー処理をしている部分が?のついた一箇所しかないこと
  ## それにも関わらず、前段の関数でエラーが発生した場合、最終的な結果にそれが反映される
  ## つまり、現在の関数がエラーを吐く可能性がある場合は上記関数のようにerr()を明示的に書く必要があるが、
  ## 前段のエラーを後段に伝播するだけならResult型の変数に?演算子を噛まし、入出力をResult型にすれば十分なので結構楽だと思う
  return ok(?x + 1)

func tmpSeqAdd(x: Result[seq[int], ref CatchableError], y: int): Result[int, ref CatchableError] =
  return ok((?x)[0] + 1)


#[
resultsを使用したプログラムの書き方は色々できる
しかし, 既存のライブラリは外部ライブラリであるresultsを使用していない為, それらとの相互運用性を考えると下記のように、
1. 自作関数はResult->Resultで書く
2. ライブラリの関数(Catchable errorを吐く)ものはcatchして自作関数につなげる
となる気がする
]# 

echo "parseIntOriginal (int -> Result) -> tmpAdd (Result -> Result)"
var
  tmp11 = "1".parseIntOriginal.tmpAdd(1)
  tmp12 = "hello".parseIntOriginal.tmpAdd(1)

echo typeof(tmp11)
echo typeof(tmp12)
if tmp11.isOk: echo tmp11.value else: echo "ERROR"
if tmp12.isOk: echo tmp12.value else: echo "ERROR"

echo "\n"

echo "parseInt (int -> int / raise error) -> catch (int -> Result) -> tmpAddMod (int -> Result)"
var
  tmp21 = "1".parseInt.catch.tmpAdd(1)
  tmp22 = "hello".parseInt.catch.tmpAdd(1)
echo typeof(tmp21)
echo typeof(tmp22)
if tmp21.isOk: echo tmp21.value else: echo "ERROR"
if tmp22.isOk: echo tmp22.value else: echo "ERROR"

echo "parseIntOriginal (int -> Result) -> tmpAdd (Result -> Result)"
var
  tmp31 = "1".parseSeqIntOriginal.tmpSeqAdd(1)
  tmp32 = "hello".parseSeqIntOriginal.tmpSeqAdd(1)

echo typeof(tmp11)
echo typeof(tmp12)
if tmp31.isOk: echo tmp11.value else: echo "ERROR"
if tmp32.isOk: echo tmp12.value else: echo "ERROR"

echo "\n"

echo "parseInt (int -> int / raise error) -> catch (int -> Result) -> tmpAddMod (int -> Result)"
var
  tmp41 = "1".parseInt().catch().map(func (x: int): seq[int] = @[x]).tmpSeqAdd(1)
  tmp42 = "hello".parseInt.catch.toSeq.tmpSeqAdd(1)
echo typeof(tmp21)
echo typeof(tmp22)
if tmp41.isOk: echo tmp21.value else: echo "ERROR"
if tmp42.isOk: echo tmp22.value else: echo "ERROR"
