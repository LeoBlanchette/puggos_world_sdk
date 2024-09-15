@tool
extends Node3D
class_name AvatarAnchorAssistant

@export var avatar_poser: AvatarPoser


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

## Starts the process for applying a pose to the Anchor Offsets
## avatar. Initial validation and animation (pose) loading.
## If valid, animation is forwarded to AvatarPoser.
func start_apply_pose(animation_path:String):
	if not animation_path.ends_with("/animation.tscn"):
		print("Invalid animation path. Mod file must be named animation.tscn %s"%animation_path)
		return
	var animation_dir:String = animation_path.replace("/animation.tscn", "")
	var animation_name:String = animation_dir.split("/")[-1]
	var animation_file_name:String = "%s/%s.res"%[animation_dir, animation_name]
	if not FileAccess.file_exists(animation_file_name):
		print("File not found: %s ... "%animation_file_name)
		print("File name of the actual <animation>.res should be called %s.res in this case."%animation_name)
	
	var animation = load(animation_file_name)
	if not animation is Animation:
		print("Not an animation: %s"%animation)
		print("An animation is needed for this operation.")
	avatar_poser.set_avatar_pose(animation)
