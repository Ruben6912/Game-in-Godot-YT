extends Node2D

@export var gun_data: GunData
@onready var muzzle: Node2D = $GunShaft

var time_since_last_shot: float = 0.0

func _process(delta: float) -> void:
	time_since_last_shot += delta

func fire(direction: Vector2) -> void:
	if time_since_last_shot < gun_data.fire_rate:
		return
	time_since_last_shot = 0.0

	# Calculate base angle
	var base_angle = direction.angle()

	for i in gun_data.bullets_per_shot:
		# Add random spread
		var spread = deg_to_rad(randf_range(-gun_data.spread_angle / 2.0, gun_data.spread_angle / 2.0))
		var final_angle = base_angle + spread
		var final_dir = Vector2.RIGHT.rotated(final_angle)  # RIGHT is the default "0°" vector in Godot

		# Spawn bullet
		var bullet = gun_data.bullet_scene.instantiate()
		bullet.global_position = muzzle.global_position
		bullet.configure(gun_data, final_dir)
		get_tree().current_scene.add_child(bullet)
