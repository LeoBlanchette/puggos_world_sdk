@tool
extends VBoxContainer

@onready var option_button_emote_types: OptionButton = $OptionButtonEmoteTypes

func _ready() -> void:
	generate_emotes_option_types()

func generate_emotes_option_types():
	option_button_emote_types.clear()
	for emote_type:String in Types.EmoteType.keys():
		option_button_emote_types.add_item(emote_type)


func _on_generate_item_meta_pressed() -> void:
	var idx:int = option_button_emote_types.selected
	var emote_type:String = option_button_emote_types.get_item_text(idx)
	
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.EMOTES)
	mod_meta.emote_type = emote_type
	mod_meta.generate()
