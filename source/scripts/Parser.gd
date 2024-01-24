extends Node2D


#const LEVEL0 = "Level.0.lines.json"
#const LEVEL1 = "Level.1.lines.json"

const JPATH = "res://assets/json/"

const TEST_ENDINGS  = "Test.Ending.lines.json"
const TEST_DECISION = "Test.Decisions.Test.lines.json"
const TEST_LONG_ROAD = "Test.The.Long.Road.lines.json"
const STORY_LONG_ROAD = "Story.The.Long.Road.lines.json"

var scenario_selected = STORY_LONG_ROAD

var dialogue_data = []
var dialogue_entry = 0
var dialogue_alt = false

var dialogue_actions = []
var dialogue_commands = []

#var dialogue_actions = [
	#{ "1" : [ "Yes, I would like this treat", "[CONVERSATION_2]" ] },
	#{ "2" : [ "No, that treat sounds disgusting", "[ENDING_1]" ] }
#]

signal game_over


func _ready():
	
	#print_debug(dialogue_entry)
	
	pass

#func _process(_delta):
	#pass

#func start_new_dialog( json_name ): 
func start_new_dialog(): 
	
	var jfile = JPATH + scenario_selected
	get_json_file( jfile )
	
	pass

func get_json_file( jfile ): 
	
	var json_as_text = FileAccess.get_file_as_string(jfile)
	#return JSON.parse_string(json_as_text)
	
	dialogue_data = JSON.parse_string(json_as_text)
	
	pass

func get_dialog_header( first := true ): 
	#print_debug("get_dialog_header...")
	#print(dialogue_entry)
	
	if first: dialogue_entry = 0
	else: dialogue_entry +=1
	
	#print(dialogue_entry)
	
	while dialogue_entry < dialogue_data.size(): 
		#print( dialogue_data[dialogue_entry] )
		
		if dialogue_data[ dialogue_entry ]["blockType"] == "sceneHeading":
			#print( dialogue_data[dialogue_entry] )
			
			check_for_commands()
			
			return dialogue_data[ dialogue_entry ]["text"]
		
		dialogue_entry +=1
		
		pass
	
	return "..."
	
	#pass

func get_character_next(): 
	#print_debug("get_character_next...")
	#print(dialogue_entry)
	
	while dialogue_entry < dialogue_data.size(): 
		
		if dialogue_data[ dialogue_entry ]["blockType"] == "character":
			return dialogue_data[ dialogue_entry ]["text"]
		
		dialogue_entry +=1
		
		pass
	
	return "..."
	
	#pass

func get_dialog_next(): 
	#print_debug("get_dialog_next...")
	
	while dialogue_entry < dialogue_data.size(): 
		
		if dialogue_data[ dialogue_entry ]["blockType"] == "dialogue":
			return dialogue_data[ dialogue_entry ]["text"]
		
		dialogue_entry +=1
		
		pass
	
	print_debug("game over..?")
	
	emit_signal("game_over")
	
	return "..."
	
	#pass

func check_for_commands(): 
	print_debug("check_for_commands...")
	
	dialogue_commands = []
	
	if dialogue_entry + 1 < dialogue_data.size(): 
		
		if dialogue_data[ dialogue_entry+1 ]["blockType"] == "general":
			dialogue_commands.append( dialogue_data[ dialogue_entry+1 ]["text"] )
	
	if dialogue_commands != []: 
		dialogue_entry += 1
		return true
	
	return false
	
	#pass

#var dialogue_actions = [
	#{ "1" : [ "Yes, I would like this treat", "[CONVERSATION_2]" ] },
	#{ "2" : [ "No, that treat sounds disgusting", "[ENDING_1]" ] }
#]

func check_for_action(): 
	#print_debug("check_for_action...")
	
	dialogue_actions = []
	
	if dialogue_entry + 1 < dialogue_data.size(): 
		
		if dialogue_data[ dialogue_entry+1 ]["blockType"] == "action":
			
			var action_entry = dialogue_entry + 2
			while action_entry < dialogue_data.size(): 
				
				if dialogue_data[ action_entry ]["blockType"] == "action": break
				
				if dialogue_data[ action_entry ]["blockType"] == "parenthetical":
					
					# check for instructions
					if dialogue_data[ action_entry+1 ]["blockType"] == "general":
						dialogue_actions.append( [
							dialogue_data[ action_entry+2 ]["text"],
							dialogue_data[ action_entry+3 ]["text"],
							dialogue_data[ action_entry+1 ]["text"] ] )
					
					else: 
						dialogue_actions.append( [
							dialogue_data[ action_entry+1 ]["text"],
							dialogue_data[ action_entry+2 ]["text"],
							"0" ] )
					
					#if dialogue_data[ action_entry ]["blockType"] == "general":
						#dialogue_actions.append( [
							#dialogue_data[ action_entry+3 ]["text"], ] )
					#else 
						#dialogue_actions.append( [
							#dialogue_data[ action_entry+3 ]["text"], ] )
				
				action_entry += 1
			
			return true
	
	return false
	
	#pass

func set_dialog_position( entry ): 
	#print_debug("set_dialog_position...")
	
	entry = entry.to_lower().replace("[","").replace("]","")
	#entry = entry.to_lower()
	
	var action_entry = 0 
	while action_entry < dialogue_data.size(): 
		
		if dialogue_data[ action_entry ]["blockType"] == "sceneHeading":
			
			if dialogue_data[ action_entry ]["text"].to_lower() == entry: 
				dialogue_entry = action_entry
				
				check_for_commands()
				print_debug( dialogue_commands )
				
				break
		
		action_entry += 1
		
		pass
	
	pass









