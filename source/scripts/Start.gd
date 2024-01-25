extends Node2D


var volume_value_last = 0
var game_starting = false

signal game_start
signal volume_changed


func _ready():
	
	pass

#func _process(_delta):
	#pass

func _input(event):
	
	if event.is_action_pressed("ui_accept") && !game_starting && visible: 
		game_starting = true
		_on_new_game_pressed()
	
	pass

func _on_new_game_pressed():
	#print_debug("_on_new_game_pressed...")
	
	game_starting = true
	emit_signal("game_start")
	
	pass

func _on_sound_pressed():
	
	Data.setting_music = !Data.setting_music
	
	if !Data.setting_music: 
		volume_value_last = Data.setting_volume
		Data.setting_volume = 0
	else: 
		Data.setting_volume = volume_value_last
	
	_on_set_sound()
	
	pass

func _on_set_sound(): 
	
	$Sound/On.visible = Data.setting_music
	$Sound/Slider.value = Data.setting_volume
	
	pass

func _on_volume_value_changed(value):
	
	Data.setting_volume = value
	
	$Sound/Volume.text = str( Data.setting_volume )
	
	emit_signal( "volume_changed" )
	
	pass

func _on_manager_data_loaded():
	#print_debug("_on_manager_data_loaded...")
	
	volume_value_last = Data.setting_volume
	_on_set_sound()
	
	pass






