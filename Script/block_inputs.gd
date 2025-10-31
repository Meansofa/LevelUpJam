extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%FirstTurn.connect("hidden", enable_inputs)
	%Round.connect("hidden", enable_inputs)
	%OverallWin.connect("hidden", enable_inputs)

func enable_inputs():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
