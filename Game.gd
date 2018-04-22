extends Node2D

enum {MENU, GETMOV, GETSHOOT, MOVE, GAMEOVER}

export var state = MENU
onready var actors = $"actors"
onready var player = $"actors/player"
onready var playerPos = $"playerPos"
onready var menu = $"UI/menu"
onready var GOmenu = $"UI/GOmenu"
onready var levelLabel = $"UI/level"
onready var movLine = $"UI/movLine"
onready var shootLine = $"UI/shootLine"
onready var audioPlayer = $"audioPlayerEffects"
onready var helper = $"UI/helper"

export(PackedScene) var enemy1
export(PackedScene) var enemy2
export(PackedScene) var enemy3

export(PackedScene) var level1
export(PackedScene) var level2
export(PackedScene) var level3
export(PackedScene) var level4
export(PackedScene) var level5
export(PackedScene) var level6
export(PackedScene) var level7
export(PackedScene) var level8
export(PackedScene) var level9
export(PackedScene) var level10

var level = 0
var currLevel

onready var levels = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10]


func _ready():
	randomize()
	actors.hide()
	menu.show()
	GOmenu.hide()
	levelLabel.hide()
	
func _process(delta):
	if state == GETMOV:
		helper.text = "Choose where you want to drive!"
		helper.show()
		movLine.show()
		movLine.points[0] = player.global_position
		if (get_global_mouse_position() - player.global_position).length() > player.movRange:
			movLine.points[1] = player.global_position + (get_global_mouse_position() - player.global_position).normalized() * player.movRange
		else:
			movLine.points[1] = get_global_mouse_position()
		if Input.is_action_just_pressed("clicked"):
			if (get_global_mouse_position() - player.global_position).length() > player.movRange:
				player.mov = player.global_position + (get_global_mouse_position() - player.global_position).normalized() * player.movRange
			else:
				player.mov = get_global_mouse_position()
			getShoot()
	elif state == GETSHOOT:
		helper.text = "Choose where to shoot!"
		helper.show()
		shootLine.show()
		shootLine.points[0] = player.mov
		shootLine.points[1] = get_global_mouse_position()
		if Input.is_action_just_pressed("clicked"):
			player.shoot = get_global_mouse_position()
			state = MOVE
			play()
			movLine.hide()
			shootLine.hide()
	elif state == GAMEOVER:
		helper.hide()
		levelLabel.hide()
		GOmenu.show()
	else:
		helper.hide()
	
func getMov():
	state = GETMOV
	
func getShoot():
	state = GETSHOOT
	
func calcEnemy():
	for enemy in currLevel.get_children():
		enemy.mov = enemy.global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100)).normalized() * enemy.movRange
		enemy.shoot = player.global_position
		enemy.mov()
	
func play():
	calcEnemy()
	player.mov()
	restartMov()
	
func levelUp():
	level += 1
	if level < levels.size():
		loadLevel(level)
	else:
		victory()
	
func gameOver():
	movLine.hide()
	shootLine.hide()
	state = GAMEOVER

func restartMov():
	state = GETMOV

func loadLevel(lvl):
	get_tree().call_group("enemy", "queue_free")
	levelLabel.text = "Level " + str(level + 1)
	levelLabel.show()
	player.position = playerPos.global_position
	var l = levels[lvl].instance()
	l.global_position = Vector2()
	currLevel = l
	actors.add_child(l)
	getMov()
	
func victory():
	pass #TODO
	
func _on_start_pressed():
	actors.show()
	player.show()
	levelLabel.show()
	menu.hide()
	
	#load 1st level
	loadLevel(0)

func _on_quit_pressed():
	get_tree().quit()

func _on_backToMenu_pressed():
	state = MENU
	get_tree().call_group("enemy", "queue_free")
	GOmenu.hide()
	menu.show()
	level = 0


func _on_restart_pressed():
	actors.show()
	player.show()
	levelLabel.show()
	GOmenu.hide()
	
	loadLevel(level)
