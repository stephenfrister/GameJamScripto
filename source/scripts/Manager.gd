extends Node2D


var screen_start = "res://Start.tscn"
var screen_main  = "res://Main.tscn"
var screen_end   = "res://Finish.tscn"

var scene_current = "" 


# game opens up...

# Start.tscn 
# load start page 
# -- title
# -- credits
# -- settings (music, volume, etc)
# -- options: start game, 

# Main.tscn 
# start game: 
# -- loads initial scene
# -- scene can play out through user control
# -- get to game end of game over 
# -- options: (game over, win/lose/draw? )

# Finish.tscn 
# game over: 
# -- display a message to the user
# -- maybe credits? 
# -- a way to get back to the start page

signal data_loaded


func _ready():
	
	Data.data_load()
	emit_signal("data_loaded")
	
	_on_select_scene( "start" )
	_on_set_window_position()
	_on_set_sound_level()
	_on_set_visibility()
	
	
	# pass quit notification to main
	get_tree().set_auto_accept_quit(false)
	
	pass

#func _process(_delta):
	#pass

func _on_set_window_position(): 
	#print_debug("_on_set_window_position...")
	
	get_window().position = Data.setting_position
	
	pass

func _on_game_start():
	
	$Transitions.play("start_to_main")
	
	pass

func _on_game_over(): 
	
	$Transitions.play("main_to_finish")
	
	pass

func _on_start_over(): 
	
	$Transitions.play("finish_to_start")
	
	pass

func _on_select_scene( scene ):
	#print_debug("_on_select_scene: " + str(scene) )
	
	$Start.visible  = scene == "start"
	$Main.visible   = scene == "main"
	$Finish.visible = scene == "finish"
	
	$Start._on_set_sound()
	$Main._on_set_sound()
	
	pass

func _on_set_visibility():
	
	$Transitions.play("hide_all")
	
	pass

func _on_set_sound_level(): 
	
	var setting_volume_db = linear_to_db(Data.setting_volume) - 40
	
	AudioServer.set_bus_volume_db( AudioServer.get_bus_index("Master"), setting_volume_db )
	
	if Data.setting_volume == 0: 
		AudioServer.set_bus_mute( AudioServer.get_bus_index("Master"), true )
		Data.setting_music = false
		$Start._on_set_sound()
	
	if AudioServer.is_bus_mute( AudioServer.get_bus_index("Master") ) && Data.setting_volume != 0: 
		AudioServer.set_bus_mute( AudioServer.get_bus_index("Master"), false )
		Data.setting_music = true
		$Start._on_set_sound()
	
	pass

func _notification(what):
	
	# save data when the game exits
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		
		Data.setting_position = get_window().position
		
		#print_debug( "Data.data_save on exit..." ) 
		Data.data_save()
		
		get_tree().quit()
		
		pass
	
	pass









