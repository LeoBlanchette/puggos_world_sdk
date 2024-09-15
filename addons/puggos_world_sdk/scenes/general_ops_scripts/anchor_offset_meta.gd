@tool
extends VBoxContainer

@export var pw_mods_ui: Control

@onready var option_button_pose: OptionButton = $OptionButtonPose
var pose_animation_paths:Array[String] = []
@onready var check_box_default: CheckBox = $CheckBoxDefault
@onready var check_box_aiming: CheckBox = $CheckBoxAiming

func _on_generate_item_offset_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.ITEMS)
	if check_box_default.button_pressed:
		mod_meta.offset_type = ModMeta.OffsetType.DEFAULT
	if check_box_aiming.button_pressed:
		mod_meta.offset_type = ModMeta.OffsetType.AIMING
	mod_meta.generate_anchor_offset_meta()

## A heavy function. Scans the directory for poses and 
## populates the option button. This runs every time 
## the Anchor Offset Meta panel is revealed.
func find_avatar_poses():
	if option_button_pose == null:
		return #not ready yet
	option_button_pose.clear()
	pose_animation_paths.clear()
	option_button_pose.add_item("Choose avatar pose...")
	pose_animation_paths.append("") #Just to stay consistent with index coordination
	var tscns = FileOps.get_all_files_recursive("res://mods", "tscn")
	for tscn:String in tscns:
		if tscn.contains("/pose_"):
			var ob = load(tscn).instantiate()
			var pose_id:int = ob.get_meta("id", -1)
			if pose_id == -1:
				print("Cannot use pose. No ID found in meta: %s"%tscn)
			var pose_name:String = ob.get_meta("name", ob.name)
			option_button_pose.add_item(pose_name)
			pose_animation_paths.append(tscn)
			ob.queue_free()

func _on_margin_container_anchor_offset_meta_visibility_changed() -> void:
	if pw_mods_ui.is_ui_regenerating:
		await pw_mods_ui.ui_regenerated
	if is_visible_in_tree():
		find_avatar_poses()

func _on_option_button_pose_item_selected(index: int) -> void:
	if EditorInterface.get_edited_scene_root() is not AvatarAnchorAssistant:
		print("This option is only available when the Avatar Anchor Assistant is open.:")
		print("res://tools/avatar_anchors/avatar.tscn")
		return  
	var animation_path:String = ""
	if index <= pose_animation_paths.size():
		if index == 0:
			return
		animation_path = pose_animation_paths[index]
	var avatar_anchor_assistant:AvatarAnchorAssistant = EditorInterface.get_edited_scene_root() 
	avatar_anchor_assistant.start_apply_pose(animation_path) 
	
