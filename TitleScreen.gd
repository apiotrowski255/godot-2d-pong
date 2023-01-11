extends Control

var scene_path_to_load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
		button.connect("focus_entered", self, "_on_Button_focus_entered")

func _on_Button_focus_entered() -> void:
	$AudioStreamPlayer.stream = load("res://music/270324__littlerobotsoundfactory__menu-navigate-00.wav")
	$AudioStreamPlayer.play()
	

func _on_Button_pressed(scene_to_load : String) -> void:
	scene_path_to_load = scene_to_load
	$AudioStreamPlayer.stream = load("res://music/270303__littlerobotsoundfactory__collect-point-01.wav")
	$AudioStreamPlayer.play()
	$FadeIn.show()
	$FadeIn.fade_in()


func _on_FadeIn_fade_finished() -> void:
	if scene_path_to_load == "exit":
		get_tree().quit()
	else:
		get_tree().change_scene_to(load(scene_path_to_load))
