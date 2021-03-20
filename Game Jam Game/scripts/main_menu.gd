extends Control


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://scenes/game.tscn")


func _on_Label3_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and event.is_pressed():
		OS.shell_open("https://twitter.com/OrigamiDStudio")


func _on_Label4_gui_input(event: InputEvent) -> void:
	if event as InputEventMouseButton and event.is_pressed():
		OS.shell_open("https://twitter.com/SanderVhove")
