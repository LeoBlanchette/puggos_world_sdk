@tool
extends Node3D

## This class generates meta information for icon generation. Place the object to
## be photographed under the anchor $SubViewport/Anchor and adjust accordingly.
## Then go to the PW-Mods window and press the "Generate Icon Meta" button.
class_name  IconGenerator

static var instance:Node = null

static func initialize(inst:Node):
	IconGenerator.instance = inst

static func capture_icon_meta():
	var camera_3D:Camera3D = instance.find_child("Camera3D")
	var anchor = instance.find_child("Anchor")

	if anchor.get_child_count() < 1:
		print_debug("Please place an item in the anchor node for meta capturing operation.")
		
	# Capture necessary meta
	var icon_camera_position:Vector3 = camera_3D.position
	var icon_camera_rotation:Vector3 = camera_3D.rotation_degrees
	var camera_orthographic_size:float = camera_3D.size
	
	var target:Node = anchor.get_child(0)
	
	# apply meta to editor object
	target.set_meta("icon_camera_orthographic_size", camera_orthographic_size)
	target.set_meta("icon_camera_position", icon_camera_position)	
	target.set_meta("icon_camera_rotation", icon_camera_rotation)	
		
	# now save the scene
	PuggosWorldSDK.instance.save_node_resource_meta(target)

	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IconGenerator.instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
