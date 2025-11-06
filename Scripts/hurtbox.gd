extends Area2D

var stats
var checking := false

func _on_area_entered(area):
	if not checking:
		checking = true
		start_repeating_check(area)

func _ready() -> void:
	stats = get_parent().get("resource_data")
	add_to_group("Hurtbox")
	area_entered.connect(_on_area_entered)

func _on_area_exited():
	checking = false

func start_repeating_check(area: Area2D):
	# Run indefinitely while the area is still overlapping
	while checking:
		check_area(area)
		await get_tree().process_frame  # wait 1 frame
		# Wait 29 more frames (total 30)
		for i in range(29):
			await get_tree().process_frame

func check_area(area):
	if area.is_in_group("Hitbox"):
		var attacker_parent = area.get_parent()
		var dmg = 0
		if attacker_parent.resource_data != null:
			dmg = attacker_parent.resource_data.damage
		elif area.has_method("damage_override"):
			dmg = area.damage_override

		if get_parent().has_method("take_damage"):
			get_parent().take_damage(dmg)
