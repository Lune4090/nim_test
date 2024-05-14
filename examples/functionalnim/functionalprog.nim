import sequtils, sugar, results

func generateRangeSeqRec(lo: int, hi: int): Result[seq[int], string] =
  if lo == hi:
    return ok @[hi]
  else:
    return ok @[lo] & ?generateRangeSeqRec(lo+1, hi)

echo generateRangeSeqRec(3, 10)

echo generateRangeSeqRec(3, 10).value.map(x => x*x)
echo generateRangeSeqRec(3, 10).value.map(proc(x: int): int = x*x)
