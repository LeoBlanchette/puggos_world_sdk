@tool
extends EditorPlugin


# A class member to hold the dock during the plugin life cycle.
var dock
var meta_info_popup

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	dock = preload("res://addons/puggos_world_sdk/scenes/puggos_world_sdk.tscn").instantiate()

	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.
	
	var pw_mod_exporter: PWModExporter =PWModExporter.new()
	add_export_plugin(pw_mod_exporter)
	
	add_custom_type("Mod Info", "Resource", preload("res://addons/puggos_world_sdk/scripts/mod_info.gd"), preload("res://addons/puggos_world_sdk/icons/info.svg"))
	add_custom_type("Creator Info", "Resource", preload("res://addons/puggos_world_sdk/scripts/creator_info.gd"), preload("res://addons/puggos_world_sdk/icons/info.svg"))
	


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	remove_custom_type("Mod Info")
	# Erase the control from the memory.
	dock.free()
