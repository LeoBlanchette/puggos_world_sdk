@tool
extends VBoxContainer

@onready var check_box_default: CheckBox = $CheckBoxDefault
@onready var check_box_aiming: CheckBox = $CheckBoxAiming

func _on_generate_item_offset_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.ITEMS)
	if check_box_default.toggle_mode:
		mod_meta.offset_type = ModMeta.OffsetType.DEFAULT
	if check_box_aiming.toggle_mode:
		mod_meta.offset_type = ModMeta.OffsetType.AIMING
	mod_meta.generate_anchor_offset_meta()
