extends RigidBody3D

## How much vertical force to apply when moving
@export_range(700.0, 1000.0) var thrust: float = 750.0  ## set from onspector  
## How much vertical force to apply when moving
@export_range(60.0, 100.0) var torque_thrust: float = 70.0  ## set from onspector
# Called when the node enters the scene tree for the first time.
var is_playing = true;

 # use to import Node and access to it's properties
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


func _init() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false		
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false

func _on_body_entered(body: Node) -> void:
	rocket_audio.stop()
	if is_playing: 
		if "Goal" in body.get_groups():
			compelete_level(body.file_path)
		if "Loose" in body.get_groups():
			crash_sequence()

func crash_sequence() -> void:
	is_playing = false
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
	

func compelete_level(next_level_file: String) -> void:
	is_playing = false
	success_particles.emitting = true
	success_audio.play()
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	


