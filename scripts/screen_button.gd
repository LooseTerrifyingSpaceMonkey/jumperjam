class_name ScreenButton
extends TextureButton

signal clicked(button)

func _on_pressed():
	clicked.emit(self)
