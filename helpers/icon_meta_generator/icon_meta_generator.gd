@tool
extends Node3D
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
	
	# now save the results
	var scene_path = target.scene_file_path
		
	var loaded_scene: Resource = ResourceLoader.load(scene_path, "", ResourceLoader.CacheMode.CACHE_MODE_IGNORE)
	
	var instantiated_scene = loaded_scene.instantiate()
	
	# apply meta to editor object
	target.set_meta("icon_camera_orthographic_size", camera_orthographic_size)
	target.set_meta("icon_camera_position", icon_camera_position)	
	target.set_meta("icon_camera_rotation", icon_camera_rotation)	
	
	# apply meta to source object
	instantiated_scene.set_meta("icon_camera_orthographic_size", camera_orthographic_size)
	instantiated_scene.set_meta("icon_camera_position", icon_camera_position)
	instantiated_scene.set_meta("icon_camera_rotation", icon_camera_rotation)	
	
	instantiated_scene.position = target.position	
	
	# save results
	var packed_scene = PackedScene.new()
	
	packed_scene.pack(instantiated_scene)
	packed_scene.take_over_path(scene_path)
	ResourceSaver.save(packed_scene, scene_path)
	packed_scene.emit_changed()	
	
	print("Saved to: ", scene_path)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IconGenerator.instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
