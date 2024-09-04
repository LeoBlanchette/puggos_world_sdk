@tool
extends VBoxContainer
var src:String = "res://mods/puggos_world/sandbox/animations/character/"
func _on_generate_animation_meta_pressed() -> void:
	var root:Node = get_tree().edited_scene_root
	var mod_meta:ModMeta = ModMeta.new(root, ModMeta.ModeType.ANIMATIONS)
	
	mod_meta.generate()
	
	# UNCOMMENT to auto-meta animation files
	#return
	
	var dirs = DirAccess.get_directories_at(src)
	var i = 0
	for dir in dirs:
		var anim_name = dir.replace("_", " ").capitalize()
		i=i+1
		var files = DirAccess.get_files_at(src+dir)
		for f in files:
			if f.ends_with(".tscn"):
				if f != "animation.tscn":
					print(f)
				var path = src+dir+"/"+f
				var ob:Node3D = load(path).instantiate()
				if not ob.has_meta("id"):
					ob.set_meta("id", i)
				if not ob.has_meta("name"):
					ob.set_meta("name", anim_name)
				if not ob.has_meta("mod_type"):
					ob.set_meta("mod_type", "animations")
				PuggosWorldSDK.instance.save_node_resource(ob, false)
