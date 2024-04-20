type
  Person = object
    name: string
    age: int

var person = Person(name: "John Doe", age: 20)

echo person.name

var person2 = person

person.name = "Snake"

echo person2.name


type
  PersonRef = ref object
    name: string
    age: int

var personref = PersonRef(name: "John Doe", age: 20)

echo personref.name

var personref2 = personref

personref.name = "Snake"

echo personref2.name
