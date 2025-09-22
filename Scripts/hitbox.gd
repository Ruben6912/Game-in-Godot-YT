extends Area2D

@export var damage_override: int = -1  # optional: set if you want this hitbox to deal fixed damage

var resource_data

func _ready() -> void:
	resource_data = get_parent().get("resource_data")  # optional, if parent has stats
	add_to_group("Hitbox")
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hurtbox"):
		var target_parent = area.get_parent()
		var dmg = damage_override if damage_override >= 0 else (resource_data.damage if resource_data else 0)
		if target_parent and target_parent.has_method("take_damage"):
			target_parent.take_damage(dmg)
