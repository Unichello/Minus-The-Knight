extends RigidBody2D
@onready var speed = 5
var direction := Vector2(-1,0)

func _ready():
	gravity_scale = 0

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed 
		global_position += velocity
	
func set_direction(direction: Vector2):
		self.direction = direction

