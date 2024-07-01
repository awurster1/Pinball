extends Node
const SAVEFILE_PATH = "user://highscores.json"

#Define a default highscore file
var highscores = [
	{
		"Initials": "AJW",
		"Score": 2000
	},
	{
		"Initials": "DMV",
		"Score": 1000
	},
	{
		"Initials": "CIA",
		"Score": 900
	},
	{
		"Initials": "DOT",
		"Score": 800
	},
	{
		"Initials": "DOD",
		"Score": 700
	},
	{
		"Initials": "WAP",
		"Score": 600
	},
	{
		"Initials": "SAA",
		"Score": 500
	},
	{
		"Initials": "FBI",
		"Score": 400
	},
	{
		"Initials": "MOM",
		"Score": 300
	},
	{
		"Initials": "NSA",
		"Score": 200
	}
	
]

func _ready():
	# check for no save file
	if not FileAccess.file_exists(SAVEFILE_PATH):
		# make a new save file
		save_game()
	# load save file
	load_game()

func load_game():
	if not FileAccess.file_exists(SAVEFILE_PATH):
		return # Error! We don't have a save to load.
	var tmp_save_game = FileAccess.open(SAVEFILE_PATH, FileAccess.READ)
	var save_dictionary = JSON.parse_string(tmp_save_game.get_line())
	highscores = save_dictionary['highscores']
	print(highscores)

func save_game():
	var tmp_save_game = FileAccess.open(SAVEFILE_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(
		{
			"highscores": highscores
		})
	tmp_save_game.store_line(json_string)

# Function to load a JSON file into a dictionary
func load_json_file(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()  # Close the file after reading
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var json_data = json.get_data()
			return json_data # This is the dictionary
		else:
			print("Error parsing JSON: ", json.get_error_message())
	else:
		print("Error opening file: ", file_path)
	return {}

# Get highscores in the right order
func get_sorted_highscores() -> Array:
	var sorted_highscores = highscores.duplicate()
	sorted_highscores.sort_custom(self, "Score")
	print(sorted_highscores)
	return sorted_highscores
