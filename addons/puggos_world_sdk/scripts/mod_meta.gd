@tool
extends Node

## Main class for managing Puggo's Mod Meta on the SDK side
class_name ModMeta

enum ModeType {STRUCTURES, ITEMS,}

var scene_root:Node

#region common attributes
var id:int
var mod_name:String
var mod_type:ModeType
#endregion

#region structures
enum AnchorType {NONE, FOUNDATION, PILLAR, WALL, FLOOR}
var anchor_type:AnchorType
#endregion

#region icon meta
var icon_camera_orthographic_size:float 
var icon_camera_position:Vector3
var icon_camera_rotation:Vector3
#endregion

#region mod attributes
var is_food:bool = false
var avatar_appearance_slot:int = -1
#endregion


func _init(_scene_root:Node, _mod_type:ModeType) -> void:	
	scene_root = _scene_root
	mod_type = _mod_type
	
	id = scene_root.get_meta("id", 0)
	mod_name = scene_root.get_meta("name", 0)
	
	var mod_type_string:String = scene_root.get_meta("mod_type", "-")
	
	match mod_type_string:
		"structures":
			mod_type = ModeType.STRUCTURES
			get_icon_meta()
			set_anchor_type_meta(scene_root.get_meta("anchor_type", "none"))
		"items":
			mod_type = ModeType.ITEMS
			get_appearance_item_meta()
		_:
			pass
	
## Does the meta generation after all attributes are set.
func generate()->void:
	add_basic_meta()
	match mod_type:
		ModeType.STRUCTURES:
			add_structure_meta()
			add_icon_meta()
			add_anchor_type_meta()
		ModeType.ITEMS:
			add_item_meta()
			if is_food:
				add_food_meta()
			if avatar_appearance_slot > 0:
				add_appearance_item_meta()

func add_basic_meta()->void:
	scene_root.set_meta("id", id)
	scene_root.set_meta("name", mod_name)
	
func add_structure_meta()->void:
	scene_root.set_meta("mod_type", "structures")

func add_item_meta()->void:
	scene_root.set_meta("mod_type", "items")

func add_food_meta()->void:
	#to be added later.
	pass

func add_appearance_item_meta()->void:
	scene_root.set_meta("equippable_slot", avatar_appearance_slot)
	

func add_icon_meta()->void:
	scene_root.set_meta("icon_camera_orthographic_size", icon_camera_orthographic_size)
	scene_root.set_meta("icon_camera_position", icon_camera_position)
	scene_root.set_meta("icon_camera_rotation", icon_camera_rotation)

func get_icon_meta()->void:
	icon_camera_orthographic_size = scene_root.get_meta("icon_camera_orthographic_size", 3.0)
	icon_camera_position = scene_root.get_meta("icon_camera_position", Vector3.ZERO)
	icon_camera_rotation = scene_root.get_meta("icon_camera_rotation", Vector3.ZERO)

func get_appearance_item_meta()->void:
	avatar_appearance_slot = scene_root.get_meta("equippable_slot", -1)

func add_anchor_type_meta()->void:
	var _anchor_type:="none"
	match anchor_type:
		AnchorType.NONE:
			_anchor_type = "none"
		AnchorType.FOUNDATION:
			_anchor_type = "foundation"
		AnchorType.PILLAR:
			_anchor_type = "pillar"
		AnchorType.WALL:
			_anchor_type = "wall"
		AnchorType.FLOOR:
			_anchor_type = "floor"
	scene_root.set_meta("anchor_type", _anchor_type)

func set_anchor_type_meta(_anchor_type:String)->void:
	match _anchor_type:
		"none":
			anchor_type = AnchorType.NONE
		"foundation":
			anchor_type = AnchorType.FOUNDATION
		"pillar":
			anchor_type = AnchorType.PILLAR
		"wall":
			anchor_type = AnchorType.WALL
		"floor":
			anchor_type = AnchorType.FLOOR
		_:
			anchor_type = AnchorType.NONE
