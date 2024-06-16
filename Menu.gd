extends Control


func _on_button_pressed():
	await preload("res://Particles/explosion_particles.tscn");
	await preload("res://Particles/explosion_particles.tscn");
	await preload("res://Particles/booster_particles.tscn");	
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://Level/level.tscn")
