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
func save_node_resource(ob:Node, rescan=true)->void:
	# Duplicate and set owner to null to avoid parent errors. 
	# https://docs.godotengine.org/en/4.3/classes/class_node.html#class-node-property-owner
	ob = ob.duplicate()
	ob.owner = null
	# save results
	var packed_scene = PackedScene.new()
	var file_path:String = ob.scene_file_path
	var result = packed_scene.pack(ob)
	if result == OK:		
		var error = ResourceSaver.save(packed_scene, file_path)		
		print("Saved to: ", file_path)
		if error != OK:
			push_error("An error occurred while saving the scene (%s) to disk."%file_path)
		else:
			print("Saved to: ", file_path)			
		
		if !rescan:
			return
		var filesystem = PuggosWorldSDK.instance.get_editor_interface().get_resource_filesystem()
		
		# This next silly step is required so that the editor doesn't bug you later and then 
		# confuse the user on how to reload it. So we run this silly importer 
		# which will spit out a bug that may concern the user, which we preface with a 
		# "don't worry about it" note that will likely become relevant later and 
		# cause a forum discussion about incompetence etc which maybe we can 
		# defer to a bug report on godot github which will likely never get resolved anyways.
		# Anyway, this is a cool song: https://www.youtube.com/watch?v=WzsA4TDMh0w
		print_rich("IGNORE NEXT WARNING REGARDING [b][color=red]A BUG[/color] :)[/b]")
		filesystem.reimport_files(PackedStringArray([file_path]))
	
