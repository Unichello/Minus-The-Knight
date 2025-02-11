extends Node

@onready var current_level := $Main_Menu

var reload := false
var player_state : int

func _ready():
	var settings = load("res://Scenes/Settings/Settings.tscn").instantiate()
	settings._ready()
	connect_signals()
	

func connect_signals():
	if(current_level == $Main_Menu):
		current_level.new_game.connect(_on_new_game)
		current_level.settings.connect(_on_settings)
		current_level.quit.connect(_on_quit)
	elif(current_level == $Settings):
		current_level.menu.connect(_on_menu)
	elif(current_level == $Level_2):
		current_level.next_level.connect(_on_next_level)
		current_level.win.connect(_on_win)
	elif(current_level == $WIN):
		current_level.menu.connect(_on_menu)
	else:
		current_level.next_level.connect(_on_next_level)
		
	
	
func _on_win():
	var next_level = load("res://Scenes/WIN.tscn").instantiate()
	change_level(next_level)
	
func _on_next_level(level,n):
	var next_level = level.instantiate()
	if(next_level.name != 'Main_Menu' && next_level.name != 'Settings' && next_level.name != 'WIN' ):
		next_level.st_loc = n
		next_level.get_node('CharacterBody2D').state = current_level.get_node('CharacterBody2D').state
	change_level(next_level)
		
func _on_new_game():
	var next_level = load("res://Scenes/Scene_1/Scene_1.tscn").instantiate()
	change_level(next_level)

func _on_settings():
	var next_level = load("res://Scenes/Settings/Settings.tscn").instantiate()
	change_level(next_level)

func _on_quit():
	get_tree().quit()

func _on_menu():
	var next_level = load("res://Scenes/Main_Menu/Main_Menu.tscn").instantiate()
	change_level(next_level)
	
func change_level(next_level):
	add_child(next_level)
	current_level.queue_free()
	current_level = next_level 
	connect_signals()
	
	
