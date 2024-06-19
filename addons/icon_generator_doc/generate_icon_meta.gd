@tool
extends Button

var anchor: Node = null
func _on_pressed() -> void:
	var is_valid_scene = validate_meta_generator_scene()
	if not is_valid_scene:
		print_debug("Please ensure the icon meta generator scene is open and that it has not been changed: res://helpers/icon_meta_generator/icon_meta_generator.tscn")
	var root:Node = get_tree().edited_scene_root
	IconGenerator.initialize(root)
	IconGenerator.capture_icon_meta()
	
## validates the open scene. Verifies it is the icon generator scene, then 
## ensures all the working parts are present.
func validate_meta_generator_scene() -> bool:
	var root:Node = get_tree().edited_scene_root
	if root.name != "IconGenerator":
		return false
	var sprite_2d = root.find_child("Sprite2D")
	var sub_viewport = root.find_child("SubViewport")
	var camera_3d = root.find_child("Camera3D")
	var anchor = root.find_child("Anchor")
	if sprite_2d == null:
		return false
	if sub_viewport == null:
		return false
	if camera_3d == null:
		return false
	if anchor == null:
		return false
	return true
