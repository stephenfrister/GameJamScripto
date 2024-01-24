extends Node


var version_game = "2024.0123.01"
var version_cfg = 0

#var default_save = OS.get_unique_id()
#var setting_save = default_save

var music_enabled = true
var music_volume = 50

var settings_loaded          = false
#var settings_loaded_secure   = false

var default_theme  = "blue"
var default_music  = true
var default_music_type = "mute"
var default_volume = 50
var default_position = Vector2( 100, 100 )

var setting_theme    = default_theme
var setting_music    = default_music
var setting_volume   = default_volume
var setting_position = default_position
var setting_music_type = default_music_type


func _ready():
	pass

func data_save():
	#print_debug("data_save...")
	
	# initiate config file 
	var config = ConfigFile.new()  
#	var _err = config.load("user://settings.cfg")
	
	config.set_value("version", "version", version_game)
	#config.set_value("save", "setting_save", setting_save)
	
	config.set_value("settings", "setting_theme", setting_theme)
	config.set_value("settings", "setting_music", setting_music)
	config.set_value("settings", "setting_volume", setting_volume)
	config.set_value("settings", "setting_position", setting_position)
	config.set_value("settings", "setting_music_type", setting_music_type)
	
	# save config file 
	config.save("user://settings.cfg")
	
	#data_save_secure()
	
	pass

func data_load(): 
	#print_debug("data_load...")
	
	# load config file data 
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	# If the file didn't load, ignore it.
	if err != OK:
		return
	
	version_cfg          = config.get_value("version", "version", 0)
	#setting_save         = config.get_value("save", "setting_save", default_save)
	
	setting_theme       = config.get_value("settings", "setting_theme", default_theme)
	setting_music        = config.get_value("settings", "setting_music", default_music)
	setting_volume       = config.get_value("settings", "setting_volume", default_volume)
	setting_position     = config.get_value("settings", "setting_position", default_position)
	setting_music_type     = config.get_value("settings", "setting_music_type", default_music_type)
	
	#print_debug("load setting_volume: " + str(default_volume) )
	
	settings_loaded = true
	#data_load_secure()
	
	pass

#func data_save_secure(): 
	##print_debug("data_save_secure...")
	#
	#var config = ConfigFile.new()
	#var _err = config.load_encrypted_pass("user://datafile.cfg", setting_save)
	#
	## save config file 
	#config.save_encrypted_pass("user://datafile.cfg", setting_save)
	#
	#pass
#
#func data_load_secure(): 
	##print_debug("data_load_secure...")
	#
	## load config file data 
	#var config = ConfigFile.new()
	#var err = config.load_encrypted_pass("user://datafile.cfg", setting_save)
##	var err = config.load("user://datafile.cfg")
	#
	## If the file didn't load, ignore it.
	#if err != OK:
		#return
	#
	#settings_loaded_secure = true
	#
	#pass





