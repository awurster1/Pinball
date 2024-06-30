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
	highscores = highscore.highscores
	# Load high scores
	print(str(highscores))
	#printing individual scores+variables
	for hs in highscores:
		print(str(hs))
		print("      ")
		print(int(hs["Score"]))
		print(str(hs["Initials"]))
		
	#print(str(initials) + str(Score))
	# Populate the labels array with the Label nodes
	for child in get_children():
		if child is Label:
			labels.append(child)
			child.text = "0"  # Initialize labels with "0"
	
	# Highlight the first label initially
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
	# Count the number of Label nodes under Control
	var label_count = 0
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Label and child.visible:
			label_count += 1
			print("Label count is: " + str(label_count))

	var label = labels[selected_label_index]
	var current_text = label.text
	
	if label_count == 3:
		player_initials = _calculate_initials(combined_label_values)
		print(str(player_initials))
	else:
		player_score = _calculate_score(combined_label_values)
		print(str(player_score))
	print("Player score:", player_score)
	if state == 0:
		print("state:" + str(state))
		_is_high_score()
		state += 1
		print("state:" + str(state))
	else:
		print("state:" + str(state))
		_is_high_score()
		get_tree().change_scene_to_file("res://highscore.tscn")
		
	  # Debug print
	#if _is_high_score(player_score):
		#print("New high score!")  # Debug print
		#_prepare_for_initials_input()
		#high_scores.add_score(combined_label_values, player_score)
		#_save_high_scores()

func _highlight_selected_label():
	# Reset all labels to default color
	for label in labels:
		label.add_theme_color_override("font_color", Color(1, 1, 1))  # Set to default white
	# Highlight the selected label
	labels[selected_label_index].add_theme_color_override("font_color", Color(1, 0, 0))  # Set to red

func _change_label_text(action: String):
	# Get the Control node
	var label_count = 0

	# Count the number of Label nodes under Control
	for child in get_node("/root/Node2D/Control").get_children():
		if child is Label and child.visible:
			label_count += 1
			print("Label count is: " + str(label_count))

	var label = labels[selected_label_index]
	var current_text = label.text
	
	if label_count == 3:
		# Alphanumeric characters (0-9, A-Z)
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
		# Only numeric characters (0-9)
		var current_value = current_text.to_int()
		if action == "increase":
			current_value = (current_value + 1) % 10
		elif action == "decrease":
			current_value = (current_value - 1 + 10) % 10
		label.text = str(current_value)



func _combine_label_values():
	combined_label_values = ""
	for label in labels:
		combined_label_values += label.text
	combined_label_values = combined_label_values.strip_edges()  # Remove any trailing space
	print("Combined label values:", combined_label_values)  # Debug print

func _calculate_initials(values: String):
	# Convert the combined label values into a score
	# This is a placeholder. Replace it with your actual scoring logic.
	return values
	
func _calculate_score(values: String) -> int:
	# Convert the combined label values into a score
	# This is a placeholder. Replace it with your actual scoring logic.
	return values.to_int()

func _is_high_score():
	var max_highscores = 5
	var position = len(highscore.highscores)
	print("Highscore list length: ", str(position))
	print("Highscore list content: ", str(highscore.highscores))
	
	# Check if highscore.highscores is a list of dictionaries
	if position > 0:
		print("Type of first entry: ", typeof(highscore.highscores[0]))
		if typeof(highscore.highscores[0]) != TYPE_DICTIONARY:
			print("Error: Highscore list is not a list of dictionaries.")
			return
	
	# Extract initials from labels 2-4
	player_initials = ""
	for i in range(2, 5):
		player_initials += labels[i].text
	
	# Find the correct position to insert the new value
	for i in range(len(highscore.highscores)):
		if player_score >= highscore.highscores[i]["Score"]:
			position = i
			break
	
	# Create a new highscore entry
	var new_entry = {
		"Initials": player_initials,
		"Score": player_score
	}
	
	# Insert the new value at the correct position
	highscore.highscores.insert(position, new_entry)
	
	# Remove the last element to maintain the same size
	if len(highscore.highscores) > max_highscores:
		highscore.highscores.remove_at(len(highscore.highscores) - 1)
		
	_prepare_for_initials_input()
	
	print("Updated highscore list: ", str(highscore.highscores))
	print("Player Initials are: " + str(player_initials)+" Player score is: " + str(player_score))
	if state == 0:
		pass
	else:
		highscore.save_game()
		

func _prepare_for_initials_input():
	# Hide specific labels
	state = 1
	if labels.size() >= 2:
		labels[0].visible = false
		labels[1].visible = false
	if labels.size() >= 6:
		labels[5].visible = false
	
	# Only show and reset the next few labels for initials input
	for i in range(2, 5):  # Show the 3rd, 4th, and 5th labels
		labels[i].visible = true
		labels[i].text = "A"
	
	selected_label_index = 2  # Start with the first visible initials label
	_highlight_selected_label()

