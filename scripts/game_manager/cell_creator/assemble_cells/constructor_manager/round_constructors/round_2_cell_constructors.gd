extends Node

class_name Round2CellConstructors

var turn_0 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		"lowest",
		['low', 'low'],
		[],
	),
	CellConstructor.new(
		2,
		"lowest",
		['low', 'equal'],
		[],
	),
]


var turn_1 : Array[CellConstructor] = [
	CellConstructor.new(
		4,
		"low",
		['low', 'equal'],
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
		"medium-low",
		["moderate", "equal"],
		[
			StatsToHide.new(
				'strength',
				1
			)
		]
	)
]


var turn_3 : Array[CellConstructor] = [
	CellConstructor.new(
		1,
		"medium",
		["equal"],
		[]
	),

	CellConstructor.new(
		2,
		"medium",
		["moderate", "above_average"],
		[
			StatsToHide.new(
				'strength',
				2
			)
		]		
	),

	CellConstructor.new(
		1,
		"high",
		["above_average"],
		[
			StatsToHide.new(
				'strength',
				1
			)
		]	
	),
]


var turn_4 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		"medium",
		["equal", "moderate"],
		[
			StatsToHide.new(
				'strength',
				2
			)
		]
	),

	CellConstructor.new(
		2,
		"high",
		["moderate", "moderate"],
				[
			StatsToHide.new(
				'strength',
				1,
			)
		]
		
	),
]
