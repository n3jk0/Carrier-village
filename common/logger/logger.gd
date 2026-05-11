extends Node

enum Level {
	DEBUG,
	INFO,
	WARN,
	ERROR
}

@export var minimum_level: Level = Level.INFO

func debug(...args: Array) -> void:
	_log(Level.DEBUG, args)


func info(...args: Array) -> void:
	_log(Level.INFO, args)


func warn(...args: Array) -> void:
	_log(Level.WARN, args)


func error(...args: Array) -> void:
	_log(Level.ERROR, args)


func _log(level: Level, args: Array) -> void:
	if level < minimum_level:
		return

	var level_name: String = str(Level.keys()[level])
	var timestamp: String = Time.get_datetime_string_from_system()
	var message: String = _join_args(args)
	var formatted_message: String = "[%s] [%s] %s" % [timestamp, level_name, message]

	match level:
		Level.DEBUG:
			print(formatted_message)
		Level.INFO:
			print(formatted_message)
		Level.WARN:
			push_warning(formatted_message)
		Level.ERROR:
			push_error(formatted_message)


func _join_args(args: Array) -> String:
	var parts: Array[String] = []

	for arg in args:
		parts.append(str(arg))

	return "".join(parts)
