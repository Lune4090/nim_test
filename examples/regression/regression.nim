import results
import arraymancer except read_csv

export results

type R_TenF = Result[Tensor[float], string]

proc regression*(X: Tensor[float], y: Tensor[float]): R_TenF =
  let
    Xdim = X.shape[0]
    ydim = y.shape[0]
  if Xdim != ydim:
    R_TenF.err("Dimension miss match! Xdim0: " & $Xdim & "Ydim0: " & $ydim)
  else:
    let params = X.pinv*y
    R_TenF.ok(params)
