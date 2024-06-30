extends Control

@export var scroll_speed: float = 100.0
var initial_position: Vector2

func _ready():
	# Set the text for each column with 10 high scores
	var rank_text = ""
	var initials_text = ""
	var score_text = ""
	var alternating_colors = [Color(1, 1, 1), Color(0.8, 0.8, 0.8)] # Example colors: white and light gray
	for i in range(10):
		var rank = str(i + 1) + "th:"
		if i == 0:
			rank = "1st:"
		elif i == 1:
			rank = "2nd:"
		elif i == 2:
			rank = "3rd:"
		
		# Alternate colors
		var color = alternating_colors[i % 2]
		
		rank_text += "[color=" + str(color) + "]" + rank + "[/color]" + "\n"
		initials_text += "[color=" + str(color) + "]" + str(highscore.highscores[i]["Initials"]) + "[/color]" + "\n"
		score_text += "[color=" + str(color) + "]" + str(highscore.highscores[i]["Score"]) + "[/color]" + "\n"
			
	$RankLabel.text = rank_text
	$InitialsLabel.text = initials_text
	$ScoreLabel.text = score_text

	# Get the initial position of the labels
	initial_position = $RankLabel.position
	$RankLabel.position = Vector2($RankLabel.position.x, self.size.y)
	$InitialsLabel.position = Vector2($InitialsLabel.position.x, self.size.y)
	$ScoreLabel.position = Vector2($ScoreLabel.position.x, self.size.y)

func _process(delta):
	# Update the position of the labels to scroll up
	$RankLabel.position.y -= scroll_speed * delta
	$InitialsLabel.position.y -= scroll_speed * delta
	$ScoreLabel.position.y -= scroll_speed * delta

	# Check if the text has moved completely off the top of the screen
	if $RankLabel.position.y < -$RankLabel.size.y:
		# Reset the position to the bottom of the screen
		$RankLabel.position = Vector2($RankLabel.position.x, self.size.y)
		$InitialsLabel.position = Vector2($InitialsLabel.position.x, self.size.y)
		$ScoreLabel.position = Vector2($ScoreLabel.position.x, self.size.y)
	
func _on_button_pressed():
	print("button pressed")
	get_tree().change_scene_to_file("res://save.tscn")
