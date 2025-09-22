extends Area2D

var stats

func _ready() -> void:
	stats = get_parent().get("resource_data")
	add_to_group("Hurtbox")
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		var attacker_parent = area.get_parent()
		var dmg = 0
		if attacker_parent.resource_data != null:
			dmg = attacker_parent.resource_data.damage
		elif area.has_method("damage_override"):
			dmg = area.damage_override

		if get_parent().has_method("take_damage"):
			get_parent().take_damage(dmg)
