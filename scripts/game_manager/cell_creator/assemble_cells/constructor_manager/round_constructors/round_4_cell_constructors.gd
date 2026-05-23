extends Node

class_name Round4CellConstructors 

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
		4,
		'medium-low',
		['equal', 'high'],
		[
			StatsToHide.new('strength',2),
			StatsToHide.new('intelligence',2),
			StatsToHide.new('community',2),
		]
	)
]

var turn_1 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		'medium-low',
		['above_average'],
		[
			StatsToHide.new('strength',2),
			StatsToHide.new('intelligence',1),
			StatsToHide.new('community',1),
		]
	),
	CellConstructor.new(
		2,
		'medium-low',
		['moderate', 'above_average'],
		[
			StatsToHide.new('strength',1),
			StatsToHide.new('intelligence',1),
			StatsToHide.new('community',2),
		]
	)
]


var turn_2 : Array[CellConstructor] = [
	CellConstructor.new(
		1,
		'low',
		['equal'],
		[
			StatsToHide.new('strength',1),
		]
	),
	CellConstructor.new(
		1,
		'medium-low',
		['moderate'],
		[
			StatsToHide.new('community',1),
		]
	),
	CellConstructor.new(
		2,
		'medium',
		['high', 'above_average'],
		[
			StatsToHide.new('strength',1),
			StatsToHide.new('intelligence',2),
			StatsToHide.new('community',1),
			
		]
	)
]


var turn_3 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		'medium-low',
		['moderate', 'equal'],
		[
			StatsToHide.new('community',1),
			StatsToHide.new('strength',2),
		]
	),
	CellConstructor.new(
		2,
		'medium',
		['high', 'equal'],
		[
			StatsToHide.new('strength',1),
			StatsToHide.new('intelligence',2),
			StatsToHide.new('community',1),
			
		]
	)
]


var turn_4 : Array[CellConstructor] = [
	CellConstructor.new(
		2,
		'medium-elevated',
		['moderate', 'above_average'],
		[
			StatsToHide.new('community',1),
			StatsToHide.new('strength',2),
			StatsToHide.new('intelligence',1),
		]
	),
	CellConstructor.new(
		2,
		'high',
		['high'],
		[
			StatsToHide.new('strength',1),
			StatsToHide.new('intelligence',1),
			StatsToHide.new('community',2),
			
		]
	)
]

var turn_5 : Array[CellConstructor] = [
	CellConstructor.new(
		1,
		'medium-elevated',
		['above_average'],
		[
			StatsToHide.new('community',1),
			StatsToHide.new('intelligence',1),
		]
	),
	CellConstructor.new(
		2,
		'high',
		['high', 'above_average'],
		[
			StatsToHide.new('strength',1),
			StatsToHide.new('intelligence',1),
			StatsToHide.new('community',1),
			
		]
	),
		CellConstructor.new(
		1,
		'high',
		['equal'],
		[
			StatsToHide.new('strength', 1),
			StatsToHide.new('community',1),
			
		]
	)
]
