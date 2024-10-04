@tool
extends VBoxContainer

@onready var anchor_type_option_button: OptionButton = $HBoxContainer/AnchorTypeOptionButton

func _ready() -> void:
	for structure_type in Types.ModularStructureType.keys():
		anchor_type_option_button.add_item(structure_type)

func _on_generate_modular_structure_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.STRUCTURES)
	
	var anchor_type_selected_id = anchor_type_option_button.get_selected_id()
	
	if anchor_type_selected_id > -1:
		
		var anchor_type_selected_text = anchor_type_option_button.get_item_text(anchor_type_selected_id)
		
		mod_meta.set_structure_type_meta(anchor_type_selected_text)
		
		mod_meta.generate()
