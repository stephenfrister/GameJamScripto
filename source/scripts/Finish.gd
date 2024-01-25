extends Node2D


var game_ending = false

signal start_over


func _ready():
	pass

#func _process(_delta):
	#pass

func _input(event):
	
	if event.is_action_pressed("ui_accept") && game_ending && visible: 
		game_ending = true
		_on_start_pressed()
	
	pass


func _on_start_pressed():
	
	emit_signal("start_over")
	
	pass

func _on_link_pressed():
	
	OS.shell_open("https://www.scripto.live")
	
	pass









