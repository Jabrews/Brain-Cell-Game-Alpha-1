extends Node

### defect event manager parent ### 
var defect_event_update_timer_duration = 10

var no_event_chance = 40
var jolt_cell_container_chance = 30
var jolt_hidden_stat_interpreter_chance = 30

####################################



### jolt hidden stat interpreter ###

# all get a jolt
# if ran_num (0 - 100) is below 25
# if it is aboce then we do single jolt (below vars)
var chance_for_multiple_hidden_stat_interpreter_jolt = 25

# indivutal jolt chances (when only one interpreter)
var jolt_strength_chance = 33
var jolt_intelligence_chance = 66
var jolt_community_chance = 100

# the value in which we increase
var interpreter_jolt_defect_increase = 20
######################################

### jolt cell container ###

# the value in which we increase
var cell_container_jolt_defect_increase = 10
######################################
