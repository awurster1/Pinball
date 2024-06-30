extends Control

@export var scroll_speed: float = 100.0
var initial_position: Vector2

func _ready():
	# Set the text for each column
	$RankLabel.text = "1st:\n2nd:\n3rd:\n4th:\n5th:"
	$InitialsLabel.text = str(highscore.highscores[0]["Initials"]) + "\n" + str(highscore.highscores[1]["Initials"]) + "\n" + str(highscore.highscores[2]["Initials"]) + "\n" + str(highscore.highscores[3]["Initials"]) + "\n" + str(highscore.highscores[4]["Initials"])
	$ScoreLabel.text = str(highscore.highscores[0]["Score"]) + "\n" + str(highscore.highscores[1]["Score"]) + "\n" + str(highscore.highscores[2]["Score"]) + "\n" + str(highscore.highscores[3]["Score"]) + "\n" + str(highscore.highscores[4]["Score"])

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
