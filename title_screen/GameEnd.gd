extends Control


onready var label: Label = $CenterContainer/Label

func set_text(string : String) -> void:
	label.text = string
