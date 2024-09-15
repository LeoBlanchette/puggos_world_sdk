@tool
extends VBoxContainer

# IDs
@onready var check_button_basic_interaction: CheckButton = $CheckButtonBasicInteraction
@onready var check_button_primary_action: CheckButton = $CheckButtonPrimaryAction
@onready var check_button_secondary_action: CheckButton = $CheckButtonSecondaryAction
@onready var check_button_primary_action_alt: CheckButton = $CheckButtonPrimaryActionAlt
@onready var check_button_secondary_action_alt: CheckButton = $CheckButtonSecondaryActionAlt
@onready var check_button_long_idle: CheckButton = $CheckButtonLongIdle

# Masks
@onready var check_button_basic_interaction_mask: CheckButton = $CheckButtonBasicInteractionMask
@onready var check_button_primary_action_mask: CheckButton = $CheckButtonPrimaryActionMask
@onready var check_button_secondary_action_mask: CheckButton = $CheckButtonSecondaryActionMask
@onready var check_button_primary_action_alt_mask: CheckButton = $CheckButtonPrimaryActionAltMask
@onready var check_button_secondary_action_alt_mask: CheckButton = $CheckButtonSecondaryActionAltMask
@onready var check_button_long_idle_mask: CheckButton = $CheckButtonLongIdleMask

func _on_generate_item_action_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.MISC)
	
	if check_button_basic_interaction.button_pressed:
		mod_meta.add_basic_interaction_animation_id = true
	if check_button_primary_action.button_pressed:
		mod_meta.add_primary_action_animation_id = true
	if check_button_secondary_action.button_pressed:
		mod_meta.add_secondary_action_animation_id = true
	if check_button_primary_action_alt.button_pressed:
		mod_meta.add_primary_action_alt_animation_id = true
	if check_button_secondary_action_alt.button_pressed:
		mod_meta.add_secondary_action_alt_animation_id = true
	if check_button_long_idle.button_pressed:
		mod_meta.add_long_idle_animation_id = true
	
	if check_button_basic_interaction_mask.button_pressed:
		mod_meta.add_basic_interaction_animation_mask = true
	if check_button_primary_action_mask.button_pressed:
		mod_meta.add_primary_action_animation_mask = true
	if check_button_secondary_action_mask.button_pressed:
		mod_meta.add_secondary_action_animation_mask = true
	if check_button_primary_action_alt_mask.button_pressed:
		mod_meta.add_primary_action_alt_animation_mask = true
	if check_button_secondary_action_alt_mask.button_pressed:
		mod_meta.add_secondary_action_alt_animation_mask = true
	if check_button_long_idle_mask.button_pressed:
		mod_meta.add_long_idle_animation_mask = true
	
	mod_meta.generate_action_meta()
