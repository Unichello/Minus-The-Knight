extends CharacterBody2D

var game_over = load("res://Scenes/Main_Menu/Main_Menu.tscn")
@export var SPEED = 300.0
@export var  JUMP_VELOCITY = -350.0
@export var state := 1 #Armed is default
@export var hp = 6
@export var dmg = 4
@export var target : CharacterBody2D

@onready var pulo = $pulo
@onready var atacou = $atacou
@onready var dano = $dano
@onready var king = $king

var can_attack = true

var direction
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func change_state(n:int):
	state = n

func _process(delta):
	if(velocity != Vector2.ZERO):
		for i in $Sprites.get_children():
			i.play('walking')
	else:
		for i in $Sprites.get_children():
			if(i.animation == 'walking'):
				i.play('idle')
	match state:
		1: 
			for i in $Sprites.get_children():
				if(i.name  != 'Armed'):
					JUMP_VELOCITY = -350.0
					i.hide()
				else:
					i.show()
					
		2:
			for i in $Sprites.get_children():
				if(i.name != 'NoShield'):
					JUMP_VELOCITY = -390.0
					i.hide()
				else:
					i.show()
		3:
			for i in $Sprites.get_children():
				if(i.name  != 'Unarmed'):
					JUMP_VELOCITY = -420.0					
					i.hide()
				else:
					i.show()
		4:
			for i in $Sprites.get_children():
				if(i.name  != 'NoArmor'):
					SPEED = 320.0
					JUMP_VELOCITY = -420
					i.hide()
				else:
					i.show()
		5: dmg = 10000

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#for i in $Sprites.get_children():
		#	i.play('jump')
		pulo.play()


	#Handle Attack
	if Input.is_action_just_pressed('left_click'):
		for i in $Sprites.get_children():
			if(state != 4):
				i.play('attacking')
				atacou.play()
				if(state == 5):
					emit_signal("win")
		can_attack = false
		if(target != null):
			if(global_position.distance_to(target.global_position) < 120):
				target.hp = target.hp - dmg
	#Handle Death
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if(direction > 0):
			for i in $Sprites.get_children():
				i.flip_h=false
		elif(direction < 0):
			for i in $Sprites.get_children():
				i.flip_h=true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
#	#	

	move_and_slide()

func _on_armed_animation_finished():
	for i in $Sprites.get_children():
		if(i.animation == 'break'):
			change_state(2)
		i.play('idle')


func _on_no_shield_animation_finished():
	for i in $Sprites.get_children():
		if(i.animation == 'break'):
			change_state(3)
		i.play('idle')
		king.play()


func _on_unarmed_animation_finished():
	for i in $Sprites.get_children():
		i.play('idle')


func _on_no_armor_animation_finished():
	for i in $Sprites.get_children():
		i.play('idle')


func _on_arrow_detector_body_entered(body):
	if state == 1 && get_parent().name == 'Scene_5':
		$Sprites/Armed.play('break')
	elif state > 1:
		hp = hp - 1
		dano.play() 
	if(!(body is CharacterBody2D)):
		body.queue_free()
		
	
