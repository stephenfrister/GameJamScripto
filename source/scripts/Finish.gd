extends Node2D


signal start_over


func _ready():
	pass

#func _process(_delta):
	#pass


func _on_start_pressed():
	
	emit_signal("start_over")
	
	pass

func _on_link_pressed():
	
	OS.shell_open("https://www.scripto.live")
	
	pass









