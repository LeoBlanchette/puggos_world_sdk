extends EditorExportPlugin

class_name PWModExporter

var export_folder := ""
var meta_cfg:ConfigFile = null
var destination_meta_cfg:String = ""

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	export_folder = get_directory_of_file(path)
	destination_meta_cfg = export_folder+"meta.cfg"
	if FileAccess.file_exists(destination_meta_cfg):
		meta_cfg = ConfigFile.new()
		meta_cfg.load(destination_meta_cfg)

func _export_end() -> void:
	meta_cfg.save(destination_meta_cfg)

func _export_file(path: String, type: String, features: PackedStringArray) -> void:
	print(path)
	if path.ends_with("mod_info.tres"):
		write_mod_meta(path)
	if path.ends_with("creator_info.tres"):
		write_creator_meta(path)

func copy_preview_file(preview_image:Texture2D):	
	DirAccess.copy_absolute(preview_image.get_path(), export_folder+"preview.png")

func write_mod_meta(path:String):
		var meta:Resource = load(path)
		if meta_cfg == null:
			meta_cfg = ConfigFile.new()		
		var original_id = meta_cfg.get_value("steam", "id", 0)
		if original_id > 0:
			meta_cfg.set_value("steam", "id", meta.mod_id)			
		meta_cfg.set_value("puggos_world", "title", meta.mod_name)				
		var i:int = 1		
		for url in meta.urls:
			meta_cfg.set_value("puggos_world", "url_%s"%str(i), url)
			i+=1	
		if meta.mod_preview_image!=null:
			copy_preview_file(meta.mod_preview_image)	
			
func write_creator_meta(path:String):
		var meta:Resource = load(path)
		if meta_cfg == null:
			meta_cfg = ConfigFile.new()		
		meta_cfg.set_value("creator", "creator_name", meta.creator_name)			
		meta_cfg.set_value("creator", "about", meta.creator_about)				
		var i:int = 1		
		for url in meta.urls:
			meta_cfg.set_value("creator", "url_%s"%str(i), url)
			i+=1	

func get_directory_of_file(export_path:String)->String:
	var split_export_path:Array = export_path.split("/")
	var file_name:String = split_export_path[-1]
	var destination_dir = export_path.replace(file_name, "")
	return destination_dir

func _get_name() -> String:
	return "Puggos_World_Exporter"
