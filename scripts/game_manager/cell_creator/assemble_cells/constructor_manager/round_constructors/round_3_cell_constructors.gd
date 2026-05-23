extends Node

class_name Round3CellConstructors 

#CellConstructor.new(256 / 2
	#2,
	#"medium-low",
	#["moderate", "equal"],
	#[
		#StatsToHide.new(
			#'strength',
			#1
		#)
	#]
#)

var turn_0 : Array[CellConstructor] = [
	
	CellConstructor.new(
		2,
		'lowest',
		['0', 'lowest'],
		[]
	),
	
	CellConstructor.new(
		2,
		'low',
		['equal', 'moderate'],
		[
			StatsToHide.new(
				'strength',
				1,
			)
		]
	)
]

var turn_1 : Array[CellConstructor] = [
	
	CellConstructor.new(
		2,
		'medium-low',
		['above_average', 'moderate'],
		[
		StatsToHide.new('strength', 1),
		StatsToHide.new('intelligence', 1)
		],
	),
	
	CellConstructor.new(
		2,
		'low',
		['equal'],
		[
		StatsToHide.new('strength', 1)
		]
	),
	
]


var turn_2 : Array[CellConstructor] = [
	
	CellConstructor.new(
		1,
		'medium-low',
		['low'],
		[
		StatsToHide.new('intelligence', 1)
		],
	),
	
	CellConstructor.new(
		2,
		'medium',
		['above_average', 'equal'],
		[
		StatsToHide.new('strength', 1)
		]
	),
	CellConstructor.new(
		1,
		'medium',
		['moderate'],
		[
		StatsToHide.new('strength', 1),
		StatsToHide.new('intelligence', 1)
		]
	),
	
]


var turn_3 : Array[CellConstructor] = [
	CellConstructor.new(
		1,
		'medium',
		['equal'],
		[
		StatsToHide.new('strength', 1)
		],
	),
	
	CellConstructor.new(
		2,
		'medium-elevated',
		['equal'],
		[
		StatsToHide.new('intelligence', 1)	,
		StatsToHide.new('strength', 1),
		]
	),
	CellConstructor.new(
		2,
		'medium-elevated',
		['above_average'],
		[
		StatsToHide.new('strength', 1),
		StatsToHide.new('intelligence', 1)
		]
	),
]



var turn_4 : Array[CellConstructor] = [
	
	
	CellConstructor.new(
		1,
		'medium',
		['equal'],
		[
		StatsToHide.new('strength', 1),
		StatsToHide.new('intelligence', 1)	,
		],
	),
	
	CellConstructor.new(
		2,
		'medium-elevated',
		['above_average', 'high'],
		[
		StatsToHide.new('intelligence', 1)	,
		StatsToHide.new('strength', 2),
		]
	),
	CellConstructor.new(
		1,
		'high',
		['high'],
		[
		StatsToHide.new('strength', 1),
		StatsToHide.new('intelligence', 1)
		]
	),
]

# NOTE . turn 5 exist but we just repeat turn 2 or 3. i forgor
