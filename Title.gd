extends Node2D

# Declare member variables here.
var storedScore

const FILE_NAME = "user://game-data.json"

var player = {
	"hscore": 0,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game_data()
	MyGlobals.savedHighScore = player.hscore
	
	$HighScore/HighScoreNumber.text = str(MyGlobals.savedHighScore)
	
	#displays first score
	$Score/ScoreNumber.text = str(MyGlobals.score)
	
	pass 

func save_game_data():
	var file = FileAccess.open(FILE_NAME, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(player)
		file.store_string(json_string)
		file.close()
	else:
		printerr("Failed to save data to file.")

func load_game_data():
	if FileAccess.file_exists(FILE_NAME):
		var file = FileAccess.open(FILE_NAME, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			var data = JSON.parse_string(content)
			file.close()
			
			if data is Dictionary:
				player = data
			else:
				printerr("Corrupted data!")
		else:
			printerr("Failed to load data from file.")
	else:
		printerr("No saved data!")

func _input(event):
	if event is InputEventKey and event.is_pressed():
		print("loading")
		get_tree().change_scene_to_file("res://Game.tscn")

func _on_Button_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")
	pass 

func _on_Button2_pressed():
	OS.shell_open("https://doamaster.itch.io/")
	pass
