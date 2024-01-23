extends Node2D


@onready var parser = $Parser

@onready var question_name  = $Choices/Name
@onready var question_panel = $Choices/Text
@onready var question_choices = $Choices/ScrollContainer/MarginContainer/VBoxContainer

@onready var dialogue_name  = $Dialogue/Name
@onready var dialogue_panel = $Dialogue/Text
@onready var dialogue_title = $Dialogue/Title

@onready var dialog_forward = $Dialogue/Forward

@onready var inventory_text = $Inventory/Text

var text_speed = 300
var text_next = 0


func _ready():
	pass

func _process(_delta):
	
	if parser.dialogue_entry+1 >= parser.dialogue_data.size() && !$Controls/Start.visible: 
		$Controls/Start.visible = true
		
	text_speed = 20
	
	if dialogue_panel.visible_ratio < 1 && text_next < Time.get_ticks_msec(): 
		text_next = Time.get_ticks_msec() + text_speed
		dialogue_panel.visible_characters += 1
		
		if !dialog_forward.visible: 
			set_next_button(true)
	
	if dialogue_panel.visible_ratio >= 1 && dialog_forward.visible && question_choices.get_child_count() > 0: 
			set_next_button(false)
	
	#if dialog_forward.visible && : 
			#set_next_button(false)
	
	
	pass

func _input(event):
	
	if event.is_action_pressed("ui_accept") && dialog_forward.visible: 
		_on_next_pressed()
	
	pass

func _on_start_pressed():
	#print_debug("_on_start_pressed...")
	
	$Controls/Start.visible = false
	
	reset_dialog_panels()
	
	parser.start_new_dialog( parser.LPATH )
	#parser.start_new_dialog( parser.TEST3 )
	
	# resets the story pointer
	dialogue_title.text = parser.get_dialog_header(true)
	
	dialogue_panel.visible_ratio = 1
	_on_next_pressed()
	
	pass

func _on_next_pressed():
	#print_debug("_on_next_pressed...")
	
	if dialogue_panel.visible_ratio < 1: 
		dialogue_panel.visible_ratio = 1
		return
	
	dialogue_panel.visible_characters = 0
	
	var next_char = parser.get_character_next() + ":"
	var next_text = parser.get_dialog_next()
	
	#if next_char == "Dog:": 
		#dialogue_name.text = next_char
		#dialogue_panel.text = next_text
	
	if next_char == "Location:": 
		question_name.text = next_char
		question_panel.text = next_text
	
	else: 
		dialogue_name.text = next_char
		dialogue_panel.text = next_text
	
	if parser.check_for_action(): 
		create_action_list()
		set_next_button( false )
	else: 
		set_next_button( true )
	
	pass

func create_action_list(): 
	#print_debug("create_action_list...")
	
	for action in parser.dialogue_actions: 
		#print(action)
		
		if action[2] != "hidden":
		
			var new_button = Button.new()
			new_button.text = action[0]
			new_button.connect( "pressed", select_action_item.bind( action ) )
			
			question_choices.add_child( new_button )
		
		pass
	
	pass

func create_command_items(): 
	#print_debug("create_command_items...")
	#print(parser.dialogue_commands)
	
	var command_items = [] 
	for item in parser.dialogue_commands: 
		command_items.append( item.split("=") )
	
	#print( command_items[0] )
	
	inventory_text.text += command_items[0][1].to_pascal_case ()
	
	parser.dialogue_commands = []
	
	pass

func reset_dialog_panels(): 
	
	dialogue_title.text = "..."
	dialogue_panel.text = "..." 
	question_panel.text = "..."
	
	inventory_text.text = ""
	
	# remove any objects previously added to the container 
	for old in question_choices.get_children(): 
		old.queue_free()
	
	set_next_button( false )
	
	pass

func select_action_item( item ): 
	
	dialogue_panel.visible_ratio = 1
	
	reset_dialog_panels()
	dialogue_panel.text = item[0]
	
	parser.set_dialog_position( item[1] )
	set_next_button( true )
	
	if parser.dialogue_commands != []: 
		create_command_items()
	
	_on_next_pressed()
	
	pass

func set_next_button( value ): 
	
	#print_debug( parser.dialogue_entry + 1 >= parser.dialogue_data.size() )
	#print_debug( parser.dialogue_entry + 1 )
	#print_debug( parser.dialogue_data.size() )
	
	if parser.dialogue_entry + 1 >= parser.dialogue_data.size(): 
		dialog_forward.visible = false
	
	else: 
		dialog_forward.visible = value
	
	pass

func set_theme_1(): 
	
	set_theme( "res://assets/themes/style_box_flat_blue_light.tres" )
	
	pass

func set_theme_2(): 
	
	set_theme( "res://assets/themes/style_box_flat_green_light.tres" )
	
	pass

func set_theme_3(): 
	
	set_theme( "res://assets/themes/style_box_flat_purple_light.tres" )
	
	pass

func set_theme( theme ): 
	
	$Dialogue/Panel.set( "theme_override_styles/panel", load(theme) )
	$Choices/Panel.set( "theme_override_styles/panel", load(theme) )
	
	pass






#func _on_select_1_pressed():
	#print_debug("_on_select_1_pressed...")
	#
	#var jtext = parser.get_json_file( parser.JPATH, parser.LEVEL1 )
	#dialogue_panel.text = str(jtext)
	#
	#dialogue_panel.text = ""
	#
	#for item in jtext: 
		#print(item)
		#
		#if item["blockType"] == "dialogue":
			#dialogue_panel.text += item["text"] + ": "
		#
		#if item["blockType"] == "action":
			#dialogue_panel.text += item["text"] + "\n"
			#
			#pass
	#
	#pass # Replace with function body.





