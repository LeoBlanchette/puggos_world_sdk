@tool
extends VBoxContainer

func _on_button_id_tracking_pressed() -> void:
	var id_tracker:IdTracker = IdTracker.new()
	id_tracker.analyze_mods()
	id_tracker.print_to_console()
	
