extends Node2D


@onready var parser = $Parser

@onready var question_name  = $Choices/Name
@onready var question_panel = $Choices/Text
@onready var question_choices = $Choices/ScrollContainer/MarginContainer/VBoxContainer

@onready var dialogue_name  = $Character/Name
@onready var dialogue_panel = $Dialogue/Text
@onready var dialogue_title = $Dialogue/Title

@onready var dialog_forward = $Dialogue/Forward

@onready var inventory_text = $Inventory/Text

var music_type = Data.setting_music_type

var text_speed = 20
var text_next = 0

var story_started = false

signal game_over
signal volume_changed


func _ready():
	pass

func _process(_delta):
	
	#if parser.dialogue_entry+1 >= parser.dialogue_data.size() && !$Controls/Start.visible: 
		#$Controls/Start.visible = true
	
	if !story_started && visible: 
		story_started = true
		
		#TODO: something here to start the story...
		#print_debug("story start...")
		_on_select_scenario( "story" )
		
	
	if story_started && !visible: 
		story_started = false
		
		#TODO: clear any necessary story variables...
		#print_debug("story end...")
	
	if dialogue_panel.visible_ratio < 1 && text_next < Time.get_ticks_msec(): 
		text_next = Time.get_ticks_msec() + text_speed
		dialogue_panel.visible_characters += 1
		
		if !dialog_forward.visible: 
			set_next_button(true)
	
	if dialogue_panel.visible_ratio >= 1 && dialog_forward.visible && question_choices.get_child_count() > 0: 
			set_next_button(false)
	
	if music_type != Data.setting_music_type: 
		music_type = Data.setting_music_type
		
		_on_sound_pressed( music_type )
		
		pass
	
	pass

func _input(event):
	
	if event.is_action_pressed("ui_accept") && dialog_forward.visible: 
		_on_next_pressed()
	
	pass

func _on_select_scenario( type ): 
	
	if type   == "story":  parser.scenario_selected = parser.STORY_LONG_ROAD
	elif type == "test":   parser.scenario_selected = parser.TEST_LONG_ROAD
	elif type == "simple": parser.scenario_selected = parser.TEST_DECISION
	elif type == "ending": parser.scenario_selected = parser.TEST_ENDINGS
	else: 
		#print_debug( "type not found: " + str(type) )
		pass
	
	_on_start_pressed()
	
	pass

func _on_start_pressed():
	#print_debug("_on_start_pressed...")
	
	#$Controls/Start.visible = false
	
	reset_dialog_panels()
	
	parser.start_new_dialog()
	
	# resets the story pointer
	dialogue_title.text = parser.get_dialog_header(true)
	dialogue_panel.text = parser.get_dialog_next()
	
	dialogue_panel.visible_ratio = 0
	
	#_on_next_pressed()
	
	#print_debug(dialogue_title.text)
	#print_debug(ialogue_panel.text)
	
	pass

func _on_next_pressed():
	#print_debug("_on_next_pressed...")
	
	$Dialogue/Instruction.visible = false
	
	if dialogue_panel.visible_ratio < 1: 
		dialogue_panel.visible_ratio = 1
		
		# this might be causing the text to not appear sometimes...
		
		return
	
	var next_char = parser.get_character_next().capitalize()
	var next_text = parser.get_dialog_next()
	var commands  = parser.check_for_commands()
	
	if commands: 
		set_dialogue_popout( parser.dialogue_commands[0] )
	else: 
		set_dialogue_popout( "" )
	
	#print_debug( "next_char: " + next_char )
	#print( ["Punk Girl","Action"].has( next_char ) )
	
	if  !["Punk Girl","Action","Ending"].has( next_char ): 
		_on_show_character( next_char )
	
	if next_char == "Action": 
		question_name.text = next_char
		#question_panel.text = next_text
		question_panel.text = "[center]" + next_text + "[/center]"
	
	else: 
		dialogue_panel.visible_characters = 0
		dialogue_name.text = next_char
		dialogue_panel.text = next_text
		#dialogue_panel.text = "[center]" + next_text + "[/center]"
		
		# TODO: why isn't the text showing up sometimes? 
		
		#print_debug("next_text: " + next_text )
		#print_debug("text_next: " + str(text_next) )
		#print_debug("dialogue_panel.visible_ratio: " + str(dialogue_panel.visible_ratio) )
		
		#return
	
	if parser.check_for_action(): 
		
		#print_debug( "next_char: " + next_char )
		#print_debug( "next_text: " + next_text )
		#print_debug( "actions: " + str( parser.dialogue_actions ) )
		
		create_action_list()
		set_next_button( false )
	
	else: 
		set_next_button( true )
	
	#if next_char == "Dog:": 
		#dialogue_name.text = next_char
		#dialogue_panel.text = next_text
	
	#if next_char == "Location:": 
		#question_name.text = next_char
		#question_panel.text = next_text
	
	#print_debug("end next...")
	
	pass

func _on_show_character( character ): 
	#print_debug("_on_show_character: " +  character )
	
	$Companion/Trinity.visible = false
	$Companion/Crow.visible = false
	$Companion/Evil.visible = false
	$Companion/Person.visible = false
	
	if character == "Trinity"  : $Companion/Trinity.visible = !$Companion/Trinity.visible   # rabbit
	if character == "Stranger" : $Companion/Crow.visible    = !$Companion/Crow.visible      # crow
	if character == "Alien"    : $Companion/Person.visible  = !$Companion/Person.visible    # alien
	if character == "Evil"     : $Companion/Evil.visible    = !$Companion/Evil.visible      # invert
	
	$Companion/Trin.visible = $Companion/Trinity.visible
	$Companion/Shop.visible = $Companion/Person.visible
	$Companion/Ranger.visible = $Companion/Crow.visible 
	
	pass

func _on_clicker_pressed():
	
	if $Dialogue/Forward.visible: 
		_on_next_pressed()
	
	pass

func reset_dialog_panels(): 
	#print_debug("reset_dialog_panels...")
	
	$Dialogue/Left.visible = false
	$Dialogue/Right.visible = false 
	
	dialogue_title.text = "..."
	dialogue_panel.text = "..." 
	#dialogue_panel.text = "  " 
	
	question_panel.text = ""
	inventory_text.text = ""
	
	# remove any objects previously added to the container 
	for old in question_choices.get_children(): 
		old.queue_free()
	
	set_next_button( false )
	
	pass

func set_next_button( value ): 
	
	if parser.dialogue_entry + 1 >= parser.dialogue_data.size(): 
		dialog_forward.visible = false
	
	else: 
		dialog_forward.visible = value
	
	pass

func set_dialogue_popout( value ): 
	
	$Dialogue/Left.visible = ( value == "left" )
	$Dialogue/Right.visible = ( value == "right" )
	
	pass

func select_action_item( item ): 
	#print_debug("create_action_list...")
	#print(item)
	
	dialogue_panel.visible_ratio = 1
	
	reset_dialog_panels()
	dialogue_panel.text = item[0]
	
	parser.set_dialog_position( item[1] )
	set_next_button( true )
	
	if parser.dialogue_commands != []: 
		create_command_items()
	
	_on_next_pressed()
	
	pass

func create_action_list(): 
	#print_debug("create_action_list...")
	
	for action in parser.dialogue_actions: 
		#print(action)
		
		if action[2] != "hidden":
		
			var new_button = Button.new()
			new_button.text = action[0]
			new_button.connect( "pressed", select_action_item.bind( action ) )
			
			#var button_font = "res://assets/fonts/Kalam-Regular.ttf"
			#var button_font = "res://assets/fonts/SpaceMono-Regular.ttf"
			#var button_font = "res://assets/fonts/EduBeginner-Regular.ttf"
			
			var button_font = "res://assets/fonts/EduBeginner-Regular.ttf"
			new_button.set( "theme_override_fonts/font", load(button_font) )
			new_button.set("theme_override_font_sizes/font_size", 20)
			
			#$Dialogue/Panel.set( "theme_override_styles/panel", load(theme) )
			
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
	
	if command_items[0].size() > 1: 
		inventory_text.text += command_items[0][1].to_pascal_case ()
	
	parser.dialogue_commands = []
	
	pass

func _on_slider_value_changed(value):
	
	Data.setting_volume = value
	
	_on_set_sound()
	
	emit_signal("volume_changed")
	
	pass

#https://freepd.com/music/City%20Sunshine.mp3
#https://freepd.com/music/Mysterious%20Lights.mp3
func _on_sound_pressed( type ):
	#print_debug("_on_sound_pressed...")
	
	music_type = type
	
	var music_sun  = $Sound/Sunshine/Music
	var music_moon = $Sound/Mystery/Music
	
	music_sun.playing  = type == "sunshine"
	music_moon.playing = type == "mystery"
	
	Data.setting_music_type = type
	
	pass

func _on_set_sound(): 
	
	$Sound/Slider.value = Data.setting_volume
	$Sound/Volume.text = str( Data.setting_volume )
	
	pass

func _on_set_theme(): 
	#print_debug("_on_set_theme...")
	
	if Data.setting_theme == "blue":  set_theme_1()
	if Data.setting_theme == "green": set_theme_2()
	if Data.setting_theme == "red":   set_theme_3()
	
	pass

func _on_finish_pressed():
	
	emit_signal("game_over")
	
	pass

func _on_parser_game_over():
	
	emit_signal("game_over")
	
	pass

func _on_manager_data_loaded():
	
	_on_set_sound()
	_on_set_theme()
	
	pass

func set_theme( theme ): 
	
	$Dialogue/Panel.set( "theme_override_styles/panel", load(theme) )
	$Choices/Panel.set( "theme_override_styles/panel", load(theme) )
	$Dialogue/Left/Angle.set( "theme_override_styles/panel", load(theme) )
	$Dialogue/Right/Angle.set( "theme_override_styles/panel", load(theme) )
	
	pass

func set_theme_1(): 
	set_theme( "res://assets/themes/style_box_flat_blue_light.tres" )
	Data.setting_theme = "blue"
	
	pass

func set_theme_2(): 
	set_theme( "res://assets/themes/style_box_flat_green_light.tres" )
	Data.setting_theme = "green"
	
	pass

func set_theme_3(): 
	set_theme( "res://assets/themes/style_box_flat_purple_light.tres" )
	Data.setting_theme = "red"
	
	pass


# for testing...
func _on_twin_toggle_pressed():
	
	#$Companion/Sprite2D.visible = !$Companion/Sprite2D.visible
	
	pass





