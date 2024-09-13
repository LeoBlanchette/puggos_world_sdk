@tool
extends Control

@onready var root: VBoxContainer = $ScrollContainer/Root

@export var mode_select:OptionButton

@export var mode_menu:Array[MarginContainer]

func _ready() -> void:
	mode_select.item_selected.connect(_on_mode_selected)
	mode_select.clear()
	var i:int = 0
	for item in root.get_children():
		if item is MarginContainer:
			var option_label:String = item.get_meta("option_label", "MODE NAME NEEDED")
			mode_select.add_item(option_label, i)
		i = i+1
	mode_select.selected = 0
	mode_select.item_selected.emit(0)

func _on_mode_selected(idx:int):
	var selected_index:int = mode_select.get_item_id(idx)
	var i:int = 0
	for item in root.get_children():
		if not item is MarginContainer:
			i=i+1
			continue
		if i == selected_index:
			item.show()
		else:
			item.hide()
		i = i+1
