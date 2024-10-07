@tool
extends EditorPlugin
class_name  PuggosWorldSDK

# A class member to hold the dock during the plugin life cycle.
var dock
var meta_info_popup
var editor_selection = get_editor_interface().get_selection()
var current_selected_nodes = []
static var instance:PuggosWorldSDK


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
	editor_selection.connect("selection_changed", _on_selection_changed)
	instance = self

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	remove_custom_type("Mod Info")
	# Erase the control from the memory.
	dock.free()
	instance = null

func _on_selection_changed():
	# Returns an array of selected nodes
	current_selected_nodes = editor_selection.get_selected_nodes() 

func get_selected_nodes():
	return current_selected_nodes

## A hackish way to save a resource. Looking for a better way to do it. 
func save_node_resource_meta(ob:Node)->void:

	var file_path:String = ob.scene_file_path
	EditorInterface.open_scene_from_path(file_path)
	var root = EditorInterface.get_edited_scene_root()
	
	# Now transfer over meta data 
	var meta_data_keys:Array[StringName] = ob.get_meta_list()
	
	for meta_key:String in meta_data_keys:
		root.set_meta(meta_key, ob.get_meta(meta_key))
	EditorInterface.save_scene()
