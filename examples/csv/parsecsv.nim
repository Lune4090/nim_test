import parsecsv

var p: CsvParser
p.open("Auto.csv")
p.readHeaderRow()
while p.readRow():
  echo "new row: "
  for col in items(p.headers):
    echo "##", col, ":", p.rowEntry(col), "##"
p.close()
