# import sequtils

# var
#   sq0 = (1..10).toSeq
#   sq1 = sq0[3..6]

# var
#   sq11 = sq1

# for i in 0..<len(sq1):
#   if sq1[i] %% 2 == 0:
#     discard
#   else:
#     delete(sq11, i)

import httpclient, datamancer

let cl = newHttpClient().getContent("https://drive.google.com/uc?id=1SrmPUcMLX5mnyNsaa2E9RMOkVLUkzzzG")

echo type(cl)

let df = parseCsvString(cl)

writeFile("Auto.csv", cl)

echo df
