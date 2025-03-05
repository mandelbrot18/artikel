extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/LabelContainer/Label

#tween is manipulated by _process() and display_dialogue()
@onready var tween = get_tree().create_tween()

const CHAR_READ_RATE = 0.05
var dialogue_queue = []

enum State {
	READY, 
	READING, 
	FINISHED
}

var current_state = State.READY

func change_state(next_state):
	current_state = next_state
	"""
	match current_state:
		State.READY:
			print("changed to ready")
		State.READING:
			print("changed to reading")
		State.FINISHED:
			print("changed to finished")
	"""

# State Machine:
#
# READY  ➡  READING
#   ⬆        ⬇         
#     FINISHED
#
# READY    ➡ READING : via display_dialogue() (tween starts animation)
# READING  ➡ FINISHED : via on_tween_finished() (animation finished) 
#                        or _process() (player skips animation)
# FINISHED ➡ READY : via _process() through player input

func _ready() -> void:
	hide_textbox()
"""
	#print("starting state: ready")
	var my_script = DialogueLibrary.load_json_file("res://scripts/test_script.json")
	dialogue_queue = DialogueLibrary.extract_lines(my_script, "german")
"""

func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if !dialogue_queue.is_empty():
				display_dialogue()
			elif Input.is_action_just_pressed("ui_accept"):
				hide_textbox()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1
				tween.kill()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
	
func display_dialogue():
	#set up next text
	show_textbox()
	var next_text = dialogue_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0
	#configure state machine
	change_state(State.READING)
	#tween animation
	var duration = next_text.length() * CHAR_READ_RATE
	if tween: 
		tween.kill()
	tween = get_tree().create_tween()
	#animation: visible_ration of lable is set from zero to 1 over the time of duration
	#then emits signal "finished"
	tween.tween_property(label, "visible_ratio", 1, duration).finished
	tween.connect("finished", on_tween_finished)
	
func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func on_tween_finished():
		change_state(State.FINISHED)
	
