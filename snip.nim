import math, results

########################################
# Res: MyResult
# CatchableErrorのみを明示的ハンドリングするという思想に基づき標準化

type Res*[T] = Result[T, CatchableError]
########################################



########################################
# Grid types and their utilities
# おせろ作った時に、こういうの欲しかったので自作
# method-like(第一引数名: self)はプロパティの延長とみなしcamelCase, それ以外のfuncはsnake_caseで実装

type
  Grid2D*[T] = object
    ## original non-linear idx grid type.
    ## index: 0-index
    ## order: (x: 0, y: 0) ->(x: xlim-1, y: 0) -> (x: 0, y: 1) -> ...
    ## direction: x-positive is right side, y-positive is up side.
    gridPts: seq[T]
    xlen: int
    ylen: int

  Grid2DDirection= enum
    ## PZ means dirction (x: positive, y: zero)
    ## I deceided not to use azimuth because direction should be free from other library's coordinate implementation (y-positive is up/down side, right-handed/left-handed, ...).
    ZP
    PP
    PZ
    PN
    ZN
    NN
    NZ
    NP

func spawn_grid2D*[T](xlen: int, ylen: int): Res[Grid2D[T]] =

  if xlen > 10^9 or ylen > 10^9:
    var e: CatchableError
    new(e)
    e.msg = "Supported grid length is limited to 10^9"
    return e.err()
  elif xlen < 0 or ylen < 0:
    var e: CatchableError
    new(e)
    e.msg = "Grid length should be >= 1"
    return e.err()
    
  else:
    return Grid2D[T](
      gridPts: newSeq[T](xlen*ylen),
      xlen: xlen,
      ylen: ylen
    ).ok()

func getVal*[T](self: Grid2D[T], x: int, y: int): Res[T] =

  if x < 0 and x >= self.xlen: 
    var e: CatchableError
    new(e)
    e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen
    return e.err()

  elif y < 0 and y >= self.ylen:
    var e: CatchableError
    new(e)
    e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen
    return e.err()

  else:
    return (self.gridPts[x+y*self.xlen]).ok()

func getLinearIdx*(self: Grid2D, x: int, y: int): Res[int] =

  if x < 0 and x >= self.xlen: 
    var e: CatchableError
    new(e)
    e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen
    return e.err()

  elif y < 0 and y >= self.ylen:
    var e: CatchableError
    new(e)
    e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen
    return e.err()

  else:
    return (x+y*self.xlen).ok()

func getPos*(self: Grid2D, idx: int): Res[tuple] =

  if idx < 0 and idx >= self.xlen*self.ylen: 
    var e: CatchableError
    new(e)
    e.msg = "idx is invalid, be sure that idx is 0 <= idx < " & $self.xlen*self.ylen
    return e.err()

  else:
    return (idx mod self.xlen, idx div self.xlen).ok()
  
func getNextIdx*(self: Grid2D, x: int, y: int, dir: Grid2DDirection): Res[tuple] =

  case dir
  of ZP:
    if x < 0 and x >= self.xlen: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen
      return e.err()

    elif y < 0 and y >= self.ylen - 1:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen - 1
      return e.err()

    else:
      return (x, y+1).ok()

  of PP:
    if x < 0 and x >= self.xlen - 1: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen - 1
      return e.err()

    elif y < 0 and y >= self.ylen - 1:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen - 1
      return e.err()

    else:
      return (x+1, y+1).ok()
    
  of PZ:
    if x < 0 and x >= self.xlen - 1: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen - 1
      return e.err()

    elif y < 0 and y >= self.ylen:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen
      return e.err()

    else:
      return (x+1, y).ok()
    
  of PN:
    if x < 0 and x >= self.xlen - 1: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen - 1
      return e.err()

    elif y < 1 and y >= self.ylen:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 1 <= y < " & $self.ylen
      return e.err()

    else:
      return (x+1, y-1).ok()

  of ZN:
    if x < 0 and x >= self.xlen: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 0 <= x < " & $self.xlen
      return e.err()

    elif y < 1 and y >= self.ylen:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 1 <= y < " & $self.ylen
      return e.err()

    else:
      return (x, y-1).ok()

  of NN:
    if x < 1 and x >= self.xlen: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 1 <= x < " & $self.xlen
      return e.err()

    elif y < 1 and y >= self.ylen:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 1 <= y < " & $self.ylen
      return e.err()

    else:
      return (x-1, y-1).ok()
    
  of NZ:
    if x < 1 and x >= self.xlen: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 1 <= x < " & $self.xlen
      return e.err()

    elif y < 0 and y >= self.ylen:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen
      return e.err()

    else:
      return (x-1, y).ok()
    
  of NP:
    if x < 1 and x >= self.xlen: 
      var e: CatchableError
      new(e)
      e.msg = "x index is invalid, be sure that x index is 1 <= x < " & $self.xlen
      return e.err()

    elif y < 0 and y >= self.ylen - 1:
      var e: CatchableError
      new(e)
      e.msg = "y index is invalid, be sure that y index is 0 <= y < " & $self.ylen - 1
      return e.err()

    else:
      return (x-1, y+1).ok()
########################################



########################################
# nimPNG RGBA (str) -> arraymancer (Tensor)
# いやまあ理屈はわかるんだけどnimPNGが画素値をstrで投げてくるのでTensorに変換する

import nimPNG, arraymancer

type
  PngFormat = enum
    RGBA8
    RGB8
    GREY8
    GREYALPHA8

func getImageTensor(image:string, type: PngFormat): Tensor =
  case type
  of RGBA8
  of RGB8
  of GREY8
  of GREYALPHA8
