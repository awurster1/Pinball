extends Control

@export var scroll_speed: float = 100.0
var initial_position: Vector2

func _ready():
	#Capture the mouse to be exclusive to this program and hide it. Comment this out for debugging.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Set the text for each column with 10 high scores
	var rank_text = ""
	var initials_text = ""
	var score_text = ""
	
	for i in range(10):
		var rank = str(i + 1) + "th:"
		if i == 0:
			rank = "1st:"
		elif i == 1:
			rank = "2nd:"
		elif i == 2:
			rank = "3rd:"
		#change the text for each line; making the following line the next entry in the dictionary.
		rank_text += rank + "\n"
		initials_text += str(highscore.highscores[i]["Initials"]) + "\n"
		score_text += str(highscore.highscores[i]["Score"]) + "\n"
	
	
	#Define what each label's text contents
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
	get_tree().change_scene_to_file("res://save.tscn")
