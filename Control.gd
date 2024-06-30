extends Control

# Path to the high scores resource file
const SAVEFILE_PATH = "user://highscores.json"

# Array to hold references to the labels
var labels = []
# Index to track the currently selected label
var selected_label_index = 0
# Variable to hold the combined string of label values
var combined_label_values = ""
# Variable to hold the player's score
var player_score = 0
var player_initials: String
var highscores
# Alphabet to use for initials input
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var state = 0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	highscores = highscore.highscores
	print(str(highscores))

	for child in get_children():
		if child is Label:
			labels.append(child)
			child.text = "0"  # Initialize labels with "0"

	_highlight_selected_label()

func _on_left_pressed():
	while true:
		selected_label_index = (selected_label_index - 1 + labels.size()) % labels.size()
		if labels[selected_label_index].visible:
			break
	_highlight_selected_label()

func _on_right_pressed():
	while true:
		selected_label_index = (selected_label_index + 1) % labels.size()
		if labels[selected_label_index].visible:
			break
	_highlight_selected_label()

func _on_up_pressed():
	_change_label_text("increase")

func _on_down_pressed():
	_change_label_text("decrease")

func _on_confirm_pressed():
	print("Confirm button pressed")  # Debug print
	_combine_label_values()
	var label_count = 0
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Label and child.visible:
			label_count += 1
			print("Label count is: " + str(label_count))
	#State variable manages whether the game is in a "retrieve high score" or "retrieve initials" state
	if state == 0:
		player_score = _calculate_score(combined_label_values)
		print("Player score:", player_score)
		#check if the player has achieved a high score; If so, ask for initials. If not, show a No high score box, then go back to the main screen.
		if _is_high_score(player_score):
			_prepare_for_initials_input()
			state += 1
		else:
			#Timer for displaying the "No high score text" for only 3 seconds.
			%Title.text = "HIGH SCORE NOT ACHIEVED"
			%Title.add_theme_font_size_override("font_size",40)
			%Title.position = Vector2(20,160)
			var font_color = Color(1,0,0)
			%Title.add_theme_color_override("font_color", font_color)
			#Hide everything else
			$Label.visible = false 
			$Label2.visible = false 
			$Label3.visible = false 
			$Label4.visible = false 
			$Label5.visible = false 
			$Label6.visible = false
			$right.visible = false
			$left.visible = false
			$up.visible = false
			$down.visible = false
			$confirm.visible = false
			#Create and start a timer to wait until sending back to the home screen
			var timer := Timer.new()
			add_child(timer)
			timer.wait_time = 3.0
			timer.one_shot = true
			timer.start()
			timer.connect("timeout", Callable(self, "_on_timer_timeout"))
			
	elif state == 1:
		player_initials = _calculate_initials(combined_label_values)
		print("Player initials:", player_initials)
		_save_high_score()
		get_tree().change_scene_to_file("res://highscore.tscn")
#Timeout function for confirm button when the H.S. is not in the leaderboard
func _on_timer_timeout() -> void:
	print("timeout entered")
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Timer:
			get_tree().change_scene_to_file("res://highscore.tscn")

#function to change the color of the active number / initial when it is selected
func _highlight_selected_label():
	for label in labels:
		label.add_theme_color_override("font_color", Color(1, 1, 1))
	labels[selected_label_index].add_theme_color_override("font_color", Color(1, 0, 0))

func _change_label_text(action: String):
	var label_count = 0
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Label and child.visible:
			label_count += 1
			print("Label count is: " + str(label_count))

	var label = labels[selected_label_index]
	var current_text = label.text

	if label_count == 3:
		var alphanumeric = alphabet
		var index = alphanumeric.findn(current_text)
		if index == -1:
			index = 0
		if action == "increase":
			index = (index + 1) % alphanumeric.length()
		elif action == "decrease":
			index = (index - 1 + alphanumeric.length()) % alphanumeric.length()
		label.text = alphanumeric[index]
	else:
		var current_value = current_text.to_int()
		if action == "increase":
			current_value = (current_value + 1) % 10
		elif action == "decrease":
			current_value = (current_value - 1 + 10) % 10
		label.text = str(current_value)

func _combine_label_values():
	combined_label_values = ""
	if state == 0:
		for label in labels:
			combined_label_values += label.text
	else:
		for i in range(2, 5):
			combined_label_values += labels[i].text
	combined_label_values = combined_label_values.strip_edges()
	print("Combined label values:", combined_label_values)

func _calculate_initials(values: String):
	return values

func _calculate_score(values: String) -> int:
	return values.to_int()

func _is_high_score(score: int) -> bool:
	var max_highscores = 10
	var position = len(highscore.highscores)
	print("Highscore list length: ", str(position))
	print("Highscore list content: ", str(highscore.highscores))

	if position > 0:
		print("Type of first entry: ", typeof(highscore.highscores[0]))
		if typeof(highscore.highscores[0]) != TYPE_DICTIONARY:
			print("Error: Highscore list is not a list of dictionaries.")
			return false

	for i in range(len(highscore.highscores)):
		if score >= highscore.highscores[i]["Score"]:
			return true

	return position < max_highscores

func _prepare_for_initials_input():
	if labels.size() >= 2:
		labels[0].visible = false
		labels[1].visible = false
	if labels.size() >= 6:
		labels[5].visible = false

	for i in range(2, 5):
		labels[i].visible = true
		labels[i].text = "A"

	selected_label_index = 2
	_highlight_selected_label()

func _save_high_score():
	var max_highscores = 10
	var position = len(highscore.highscores)
	print("Highscore list length: ", str(position))
	print("Highscore list content: ", str(highscore.highscores))

	for i in range(len(highscore.highscores)):
		if player_score >= highscore.highscores[i]["Score"]:
			position = i
			break

	var new_entry = {
		"Initials": player_initials,
		"Score": player_score
	}

	highscore.highscores.insert(position, new_entry)

	if len(highscore.highscores) > max_highscores:
		highscore.highscores.remove_at(len(highscore.highscores) - 1)

	highscore.save_game()

	print("Updated highscore list: ", str(highscore.highscores))
	print("Player Initials are: " + str(player_initials) + " Player score is: " + str(player_score))
