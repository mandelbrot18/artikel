extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/LabelContainer/Label
@onready var end_symbol = $TextboxContainer/LabelContainer/End

@onready var tween = get_tree().create_tween()

const CHAR_READ_RATE = 0.05

enum State {
	READY, 
	READING, 
	FINISHED
}

var current_state = State.READY

func _ready() -> void:
	print("starting state: ready")
	#add_text("Es sitzt ein Vogel auf dem Leim.")
	add_text("es sitzt ein vogel auf dem leim er flattert sehr doch kommt nicht heim ein schwarzer kater kommt herrzu die krallen scharf die augen gluh am baum hinauf und immer höher kommt er dem armen vogel näher. der vogel spricht weil das so ist und weil mich doch der kater frisst so will ich keine zeit verlieren will noch ein wenig quinquillieren und lustig pfeifen wie zuvor der vogel scheint mir hat humor")

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			pass
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1
				tween.stop()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func on_tween_finished():
		change_state(State.FINISHED)
	
func add_text(next_text):
	change_state(State.READING)
	label.text = next_text
	var duration = next_text.length() * CHAR_READ_RATE
	show_textbox()
	tween.tween_property(label, "visible_ratio", 1, duration)
	tween.connect("finished", on_tween_finished)
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("changed to ready")
		State.READING:
			print("changed to reading")
		State.FINISHED:
			print("changed to finished")
	
