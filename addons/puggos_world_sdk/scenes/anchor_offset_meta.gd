@tool
extends VBoxContainer


func _on_generate_item_offset_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.ITEMS)
	
	mod_meta.generate_anchor_offset_meta()
