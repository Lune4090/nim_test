type
  obj0 = object of RootObj
    x0: int
  obj1 = object of obj0
    x1: int
  obj2 = object of obj1
    x2: int

let i0 = obj0(x0: 1)

var i1: obj1

i1 = obj1(x0: 2, x1: 3)

echo i1
echo typeof(i1)

i1.x0 = i0.x0

echo i1
echo typeof(i1)

func tmp(x: obj0): obj0 = 
  return obj0(x0: x.x0)

echo tmp(i1)
echo typeof(i1.tmp)
