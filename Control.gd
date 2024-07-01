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
	#Capture the mouse to be exclusive to this program and hide it. Comment this out for debugging.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	highscores = highscore.highscores
	print(str(highscores))
	#Locate each label located under "Control"
	for child in get_children():
		if child is Label:
			labels.append(child)
			child.text = "0"  # Initialize labels with "0"
	#Highlight the first label
	_highlight_selected_label()

#Runs everytime "Left" is pressed
func _on_left_pressed():
	while true:
		selected_label_index = (selected_label_index - 1 + labels.size()) % labels.size()
		if labels[selected_label_index].visible:
			break
	_highlight_selected_label()

#Runs everytime "Right" is pressed
func _on_right_pressed():
	while true:
		selected_label_index = (selected_label_index + 1) % labels.size()
		if labels[selected_label_index].visible:
			break
	_highlight_selected_label()

#Runs everytime "Up/Increase" is pressed
func _on_up_pressed():
	_change_label_text("increase")

#Runs everytime "Down/Decrease" is pressed
func _on_down_pressed():
	_change_label_text("decrease")

#Runs everytime "Confirm" is pressed.
func _on_confirm_pressed():
	print("Confirm button pressed")  # Debug print
	_combine_label_values()
	#Variable to define the amount of labels currently visible/available (used for highscore or initials input)
	var label_count = 0
	#Determine how many Labels exist
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Label and child.visible:
			label_count += 1
			print("Label count is: " + str(label_count))
	#State variable manages whether the game is in a "retrieve high score" or "retrieve initials" state
	if state == 0:
		#Take the player score from each label, then combine them into a single string
		player_score = _calculate_score(combined_label_values)
		print("Player score:", player_score)
		
		#Executes if the player's score is above any score in the leaderboard; initials screen appears
		if _is_high_score(player_score):
			_prepare_for_initials_input()
			state += 1
		#Executes if the player does not have a high score
		else:
			#Timer for displaying the "No high score text" for only 3 seconds.
			%Title.text = "HIGH SCORE NOT ACHIEVED"
			%Title.add_theme_font_size_override("font_size",40)
			%Title.position = Vector2(20,160)
			#Define the color to change the text.
			var font_color = Color(1,0,0)
			%Title.add_theme_color_override("font_color", font_color)
			#Hide all labels, except the title label
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
	#Executes after the player is determined to have a high score
	elif state == 1:
		#Take the player initials from each label, then combine them into a single string
		player_initials = _calculate_initials(combined_label_values)
		#Finally, save the high score in the array
		_save_high_score()
		#Change the scene back to the main highscore display screen.
		get_tree().change_scene_to_file("res://highscore.tscn")

#Executes after a user does not have a highscore and the timer ends
func _on_timer_timeout() -> void:
	print("timeout entered")
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Timer:
			get_tree().change_scene_to_file("res://highscore.tscn")

#Execute whenever a different digit is selected. Changes the color to red to indicate it being active.
func _highlight_selected_label():
	for label in labels:
		label.add_theme_color_override("font_color", Color(1, 1, 1))
	labels[selected_label_index].add_theme_color_override("font_color", Color(1, 0, 0))

#Execute whenever an attempt to change the digits is made (score or initials)
func _change_label_text(action: String):
	var label_count = 0
	#Execute to determine the amount of labels currently visible
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Label and child.visible:
			label_count += 1
			print("Label count is: " + str(label_count))

	var label = labels[selected_label_index]
	var current_text = label.text
	#Execute if there are 3 labels; Used for initials input
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
	#Execute if there are 6 labels (or anything except 3).
	else:
		var current_value = current_text.to_int()
		if action == "increase":
			current_value = (current_value + 1) % 10
		elif action == "decrease":
			current_value = (current_value - 1 + 10) % 10
		label.text = str(current_value)

#Execute everytime the highscore or initials are needed to be combined into one string
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

#Execute to check if the player has a high score
func _is_high_score(score: int) -> bool:
	var max_highscores = 10
	var position = len(highscore.highscores)
	print("Highscore list length: ", str(position))
	print("Highscore list content: ", str(highscore.highscores))
	#No idea what the heck this does; I think it just verifies that the highscores file is correctly formatted?
	if position > 0:
		print("Type of first entry: ", typeof(highscore.highscores[0]))
		if typeof(highscore.highscores[0]) != TYPE_DICTIONARY:
			print("Error: Highscore list is not a list of dictionaries.")
			return false
	#Check if the player has achieved a high score, and if so, return true
	for i in range(len(highscore.highscores)):
		if score >= highscore.highscores[i]["Score"]:
			return true

	return position < max_highscores

#Hide beginning and last label so that only 3 labels are visible and usable.
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

#Save the high scores
func _save_high_score():
	#Only save 10 high scores
	var max_highscores = 10
	#Variable to hold what place to save to
	var position = len(highscore.highscores)
	print("Highscore list length: ", str(position))
	print("Highscore list content: ", str(highscore.highscores))
	#Jump through the dictionary to determine where in the highscore list to save in
	for i in range(len(highscore.highscores)):
		if player_score >= highscore.highscores[i]["Score"]:
			position = i
			break
	#Variable to save into the dictionary
	var new_entry = {
		"Initials": player_initials,
		"Score": player_score
	}
	#Insert the above entry into the dictionary currently in memory
	highscore.highscores.insert(position, new_entry)
	#The above is *almost* always true, so this removes the last entry to maintain a maximum of 10 entries.
	if len(highscore.highscores) > max_highscores:
		highscore.highscores.remove_at(len(highscore.highscores) - 1)
	#FINALLY, call autoload.gd (ie highscore) and save the highscore dictionary to a file on the user's PC outside the game
	highscore.save_game()

	print("Updated highscore list: ", str(highscore.highscores))
	print("Player Initials are: " + str(player_initials) + " Player score is: " + str(player_score))
