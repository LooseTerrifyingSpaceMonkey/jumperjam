extends Node

func add_log_message(msg: String):
	var console = get_tree().get_first_node_in_group("debug_console")
	print(msg)
	if console:
		var log_label = console.find_child("LogLabel")
		if log_label:
			log_label.text += msg + "\n"
