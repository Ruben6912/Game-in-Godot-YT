extends Area2D

var speed: float
var damage: int
var lifetime: float
var direction: Vector2

func configure(gun_data: GunData, dir: Vector2) -> void:
	speed = gun_data.bullet_speed
	damage = gun_data.damage
	lifetime = gun_data.bullet_lifetime
	direction = dir.normalized()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage(damage)
	queue_free()
