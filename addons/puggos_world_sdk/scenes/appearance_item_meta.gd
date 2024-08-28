@tool
extends VBoxContainer

@onready var appearance_option_button: OptionButton = $AppearanceOptionButton

func _on_generate_appearance_item_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.ITEMS)
	
	mod_meta.avatar_appearance_slot = appearance_option_button.selected
	
	mod_meta.generate()
