@tool
extends VBoxContainer

@onready var food_check_box: CheckBox = $FoodCheckBox


func _on_generate_item_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.ITEMS)
	
	mod_meta.is_food = food_check_box.button_pressed
	
	mod_meta.generate()
