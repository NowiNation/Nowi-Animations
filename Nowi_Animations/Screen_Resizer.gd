extends Node

func _ready():
	use_best_integer_scaling()
	
func use_best_integer_scaling():
	OS.window_size = find_best_integer_scaling()
	print("Set screen size to " + str(OS.window_size))
	OS.center_window()
	
func find_best_integer_scaling()->Vector2:
	var screen_size:Vector2 = OS.get_screen_size()
	var window_size:Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/width"),\
	ProjectSettings.get_setting("display/window/size/height"))
	var ratio : float = screen_size.x / window_size.x
	ratio = min(ratio, screen_size.y / window_size.y)
	
# warning-ignore:narrowing_conversion
	var int_ratio : int = floor(ratio)
	if ratio == float(int_ratio):
# warning-ignore:narrowing_conversion
		int_ratio = max(int_ratio -1, 1)

	return window_size * int_ratio
