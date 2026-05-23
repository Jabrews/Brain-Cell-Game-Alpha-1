extends Node

class_name Round1CellConstructors

var turn_0 : Array[CellConstructor] = [
	CellConstructor.new(
		4,
		"lowest",
		["0"],
		[]
	)
]


var turn_1 : Array[CellConstructor] = [
	CellConstructor.new(
		4,
		"low",
		["low"],
		[]
	)
]


var turn_2 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		"low",
		["low", "equal"],
		[]
	),

	CellConstructor.new(
		2,
		"medium",
		["low", "equal"],
		[]
	),
]


var turn_3 : Array[CellConstructor] = [
	CellConstructor.new(
		1,
		"low",
		["equal"],
		[]
	),

	CellConstructor.new(
		2,
		"medium",
		["equal", "high"],
		[]
	),

	CellConstructor.new(
		1,
		"high",
		["above_average"],
		[]
	),
]


var turn_4 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		"medium",
		["equal", "high"],
		[]
	),

	CellConstructor.new(
		2,
		"high",
		["equal", "high"],
		[]
	),
]
