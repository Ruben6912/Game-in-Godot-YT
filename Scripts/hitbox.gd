extends Area2D

@export var damage := 10
@export var tick_rate := 0.5  # seconds between hits

var targets := {}  # Hurtbox -> Timer

func _ready() -> void:
	add_to_group("Hitbox")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("Hurtbox"):
		return

	var target = area.get_parent()
	if not target or not target.has_method("take_damage"):
		return

	# Immediate hit
	target.take_damage(damage)

	# Start repeating damage
	var timer := Timer.new()
	timer.wait_time = tick_rate
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(func():
		if is_instance_valid(target):
			target.take_damage(damage)
	)
	add_child(timer)
	targets[area] = timer

func _on_area_exited(area: Area2D) -> void:
	if targets.has(area):
		targets[area].queue_free()
		targets.erase(area)
