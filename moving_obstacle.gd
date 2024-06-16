extends AnimatableBody3D

@export var destination: Vector3
@export var duration: float = 1.0

func _ready():
	var tween = create_tween()
	tween.tween_property(self,"global_position", global_position + destination, duration)

func _process(delta):
	pass
