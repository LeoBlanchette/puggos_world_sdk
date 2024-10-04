@tool
extends Node

## Main class for managing Puggo's Mod Meta on the SDK side
## Meta information is essentially portable variables that are
## set on the mod and recognized in the game.
class_name ModMeta

enum ModeType {
	STRUCTURES, 
	ITEMS,
	ANIMATIONS, 
	EMOTES,
	MISC,
}

var scene_root:Node

#region common attributes
var id:int
var mod_name:String
var mod_type:ModeType
#endregion

#region tagging
var tag:String = ""
#endregion 

#region structures
var structure_type:Types.ModularStructureType
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

#region emotes
var emote_type:String = ""
var emote_animation_id:int = 0
#endregion 

#region anchor offsets
enum OffsetType{
	DEFAULT,
	AIMING,
}
var offset_type:OffsetType = OffsetType.DEFAULT
#endregion

#region item action animation 
var basic_interaction_animation_id:int=0
var primary_action_animation_id:int=0
var secondary_action_animation_id:int=0
var primary_action_alt_animation_id:int=0
var secondary_action_alt_animation_id:int=0
var short_idle_animation_id:int=0
var long_idle_animation_id:int=0

var basic_interaction_animation_mask:String="TORSO"
var primary_action_animation_mask:String="TORSO"
var secondary_action_animation_mask:String="TORSO"
var primary_action_alt_animation_mask:String="FULL"
var secondary_action_alt_animation_mask:String="FULL"
var short_idle_animation_mask:String="FULL"
var long_idle_animation_mask:String="FULL"

# Whether to add...
var add_basic_interaction_animation_id:bool=false
var add_primary_action_animation_id:bool=false
var add_secondary_action_animation_id:bool=false
var add_primary_action_alt_animation_id:bool=false
var add_secondary_action_alt_animation_id:bool=false
var add_short_idle_animation_id:bool=false
var add_long_idle_animation_id:bool=false

var add_basic_interaction_animation_mask:bool=false
var add_primary_action_animation_mask:bool=false
var add_secondary_action_animation_mask:bool=false
var add_primary_action_alt_animation_mask:bool=false
var add_secondary_action_alt_animation_mask:bool=false
var add_short_idle_animation_mask:bool=false
var add_long_idle_animation_mask:bool=false
#endregion 

func _init(_scene_root:Node, _mod_type:ModeType) -> void:	
	scene_root = _scene_root
	mod_type = _mod_type
	if is_avatar(): # not applicable here
		return
	id = scene_root.get_meta("id", 0)
	mod_name = scene_root.get_meta("name", "")

	var mod_type_string:String = scene_root.get_meta("mod_type", ModeType.keys()[mod_type].to_lower())

	match mod_type_string:
		"structures":
			mod_type = ModeType.STRUCTURES
			get_icon_meta()
			set_structure_type_meta(scene_root.get_meta("structure_type", "NONE"))
		"items":
			mod_type = ModeType.ITEMS
			get_appearance_item_meta()
		"emotes":
			mod_type = ModeType.EMOTES
			get_emote_meta()
		"animations":
			mod_type = ModeType.ANIMATIONS
			get_animation_meta()
		_:
			pass

	
## Does the meta generation after all attributes are set.
func generate()->void:
	add_basic_meta()
	match mod_type:
		ModeType.STRUCTURES:
			add_structure_meta()
			add_icon_meta()
			add_structure_type_meta()
		ModeType.ITEMS:
			add_item_meta()
			if is_food:
				add_food_meta()
			if avatar_appearance_slot > 0:
				add_appearance_item_meta()
		ModeType.EMOTES:
			add_emote_meta()
		ModeType.ANIMATIONS:
			add_animation_meta()

func is_avatar()->bool:
	var root_node = EditorInterface.get_edited_scene_root()
	return root_node.get_meta("avatar", false)

#region ADD META

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

func add_animation_meta():
	scene_root.set_meta("mod_type", "animations")

func add_emote_meta():
	scene_root.set_meta("mod_type", "emotes")
	scene_root.set_meta("emote_type", emote_type)
	scene_root.set_meta("tag", tag)
	scene_root.set_meta("emote_animation_id", emote_animation_id)

func add_appearance_item_meta()->void:
	scene_root.set_meta("equippable_slot", avatar_appearance_slot)

func add_item_action_meta():
	# ANIMATION IDS
	if add_basic_interaction_animation_id:
		scene_root.set_meta("basic_interaction_animation_id", basic_interaction_animation_id)
	if add_primary_action_animation_id:
		scene_root.set_meta("primary_action_animation_id", primary_action_animation_id)
	if add_secondary_action_animation_id:
		scene_root.set_meta("secondary_action_animation_id", secondary_action_animation_id)
	if add_primary_action_alt_animation_id:
		scene_root.set_meta("primary_action_alt_animation_id", primary_action_alt_animation_id)
	if add_secondary_action_alt_animation_id:
		scene_root.set_meta("secondary_action_alt_animation_id", secondary_action_alt_animation_id)
	if add_short_idle_animation_id:
		scene_root.set_meta("short_idle_animation_id", short_idle_animation_id)
	if add_long_idle_animation_id:
		scene_root.set_meta("long_idle_animation_id", long_idle_animation_id)
	# MASK TYPES
	if add_basic_interaction_animation_mask:
		scene_root.set_meta("basic_interaction_animation_mask", basic_interaction_animation_mask)
	if add_primary_action_animation_mask:
		scene_root.set_meta("primary_action_animation_mask", primary_action_animation_mask)
	if add_secondary_action_animation_mask:
		scene_root.set_meta("secondary_action_animation_mask", secondary_action_animation_mask)
	if add_primary_action_alt_animation_mask:
		scene_root.set_meta("primary_action_alt_animation_mask", primary_action_alt_animation_mask)
	if add_secondary_action_alt_animation_mask:
		scene_root.set_meta("secondary_action_alt_animation_mask", secondary_action_alt_animation_mask)
	if add_short_idle_animation_mask:
		scene_root.set_meta("short_idle_animation_mask", short_idle_animation_mask)
	if add_long_idle_animation_mask:
		scene_root.set_meta("long_idle_animation_mask", long_idle_animation_mask)

func add_icon_meta()->void:
	scene_root.set_meta("icon_camera_orthographic_size", icon_camera_orthographic_size)
	scene_root.set_meta("icon_camera_position", icon_camera_position)
	scene_root.set_meta("icon_camera_rotation", icon_camera_rotation)

func add_structure_type_meta()->void:	
	var _structure_type =Types.ModularStructureType.keys()[structure_type]
	scene_root.set_meta("structure_type", _structure_type)

func set_structure_type_meta(_structure_type:String)->void:
	match _structure_type:
		"NONE":
			structure_type = Types.ModularStructureType.NONE
		"FLOOR":
			structure_type = Types.ModularStructureType.FLOOR
		"PILLAR":
			structure_type = Types.ModularStructureType.PILLAR
		"WALL_1":
			structure_type = Types.ModularStructureType.WALL_1
		"WALL_2":
			structure_type = Types.ModularStructureType.WALL_2
		"INTERIOR_MODULE":
			structure_type = Types.ModularStructureType.INTERIOR_MODULE
		_:
			structure_type = Types.ModularStructureType.NONE

## When generating meta for actions executed on item use.
func generate_action_meta():
	get_item_action_meta()
	add_item_action_meta()

## Generates the offset values for an anchorable object such as a knife or gun.
## Since the character has multiple points where objects can be anchored, the object
## must have the offsets recorded for every anchor point it might be assigned to.
func generate_anchor_offset_meta():	
	var help:String = "Please open up res://tools/avatar_anchors/avatar.tscn"\
		+" to set anchor offsets. The item you are anchoring to the Avatar anchor"\
		+" slots must be a child of AnchorSlot_<i> and positioned accordingly."\
		+ " Then, with the item selected, push the Generate Item / Anchor Offsets button."
	# This will not work without avatar scene. Abort if not Avatar.

	if not is_avatar():
		print(help)
		return 
	# Get the selecction.
	var valid_nodes:Array = []
	var selected = PuggosWorldSDK.instance.get_selected_nodes()
	for selection in selected:
		if selection.get_parent().name.begins_with("Anchor_Slot_"):
			valid_nodes.append(selection)
	if valid_nodes.is_empty():
		print("Please select the object you wish to record anchor offsets for. "\
		+"It must be a child of an anchor slot (Anchor_Slot_<i>")
		return
	var selection:Node3D = valid_nodes[0]
	
	# Get the offset and rotation values, as well as parent (anchor) name.
	var pos:Vector3 = selection.position
	var rot:Vector3 = selection.rotation_degrees
	var anchor_slot = selection.get_parent_node_3d().name.to_lower()
	
	# Set the meta.
	match offset_type:
		OffsetType.DEFAULT:
			selection.set_meta(anchor_slot+"_position", pos)
			selection.set_meta(anchor_slot+"_rotation", rot)
		OffsetType.AIMING:
			selection.set_meta(anchor_slot+"_position_aiming", pos)
			selection.set_meta(anchor_slot+"_rotation_aiming", rot)
			
	# save results
	PuggosWorldSDK.instance.save_node_resource(selection)

#endregion ADD META 

#region GET META 
func get_item_action_meta():
	# ANIMATION IDS
	basic_interaction_animation_id = scene_root.get_meta("basic_interaction_animation_id", -1)
	primary_action_animation_id = scene_root.get_meta("primary_action_animation_id", -1)
	secondary_action_animation_id = scene_root.get_meta("secondary_action_animation_id", -1)
	primary_action_alt_animation_id = scene_root.get_meta("primary_action_alt_animation_id", -1)
	secondary_action_alt_animation_id = scene_root.get_meta("secondary_action_alt_animation_id", -1)
	short_idle_animation_id = scene_root.get_meta("short_idle_animation_id", -1)
	long_idle_animation_id = scene_root.get_meta("long_idle_animation_id", -1)
	
	# MASK TYPES
	basic_interaction_animation_mask = scene_root.get_meta("basic_interaction_animation_mask", "NONE")
	primary_action_animation_mask = scene_root.get_meta("primary_action_animation_mask", "NONE")
	secondary_action_animation_mask = scene_root.get_meta("secondary_action_animation_mask", "NONE")
	primary_action_alt_animation_mask = scene_root.get_meta("primary_action_alt_animation_mask", "NONE")
	secondary_action_alt_animation_mask = scene_root.get_meta("secondary_action_alt_animation_mask", "NONE")
	short_idle_animation_mask = scene_root.get_meta("short_idle_animation_mask", "NONE")
	long_idle_animation_mask = scene_root.get_meta("long_idle_animation_mask", "NONE")
	
func get_icon_meta()->void:
	icon_camera_orthographic_size = scene_root.get_meta("icon_camera_orthographic_size", 3.0)
	icon_camera_position = scene_root.get_meta("icon_camera_position", Vector3.ZERO)
	icon_camera_rotation = scene_root.get_meta("icon_camera_rotation", Vector3.ZERO)

func get_appearance_item_meta()->void:
	avatar_appearance_slot = scene_root.get_meta("equippable_slot", -1)

func get_animation_meta():
	pass

func get_emote_meta():
	emote_type = scene_root.get_meta("emote_type", "NONE")
	tag = scene_root.get_meta("tag", "")
	emote_animation_id = scene_root.get_meta("emote_animation_id", 0)

#endregion GET META
