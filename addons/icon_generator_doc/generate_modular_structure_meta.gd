@tool
extends Button

func _on_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	root.set_meta("id", 0.0)
	root.set_meta("name", "Modular Structure")
	root.set_meta("icon_camera_orthographic_size", "3")
	root.set_meta("icon_camera_position", Vector3.ZERO)
	root.set_meta("icon_camera_rotation", Vector3.ZERO)
