extends Control

@export var health_bar_round: TextureProgressBar
@export var damage_bar_round: TextureProgressBar
@export var health_bar_straight: TextureProgressBar
@export var damage_bar_straight: TextureProgressBar
@onready var health_show: Label = $HealthBar/HealthShow

@export var max_health := 100.0
@export var round_max := 40.0

@export var is_health: bool = false
@export var low_hp_pulse: bool = true
@export var damage_shake: bool = true

var current_pct := 1.0
var front_tween: Tween
var back_tween: Tween
var pulse_tween: Tween = null
 
func _ready():
	var health_show_text = health_bar_round.value + health_bar_straight.value - health_bar_straight.min_value
	health_show.text = str(health_show_text)
	# feste Max-Werte setzen
	health_bar_round.max_value = round_max
	damage_bar_round.max_value = round_max

	health_bar_straight.max_value = max_health - round_max
	damage_bar_straight.max_value = max_health - round_max

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_SPACE:
			update_bar(damage_bar_straight.value - 10, 100)
 
func update_bar(current: float, max_value: float):
	var health_show_text = health_bar_round.value + health_bar_straight.value - health_bar_straight.min_value
	health_show.text = str(health_show_text)
	var pct = clamp(current / max_value, 0.0, 1.0)
 
	health_bar_straight.max_value = max_value
	damage_bar_straight.max_value = max_value
 
	var is_damage = pct < current_pct
	var is_heal   = pct > current_pct
 
	if is_damage:
		if front_tween and front_tween.is_running():
			front_tween.kill()
		if back_tween and back_tween.is_running():
			back_tween.kill()
 
		health_bar_straight.value = current
 
		back_tween = create_tween()
		back_tween.tween_property(damage_bar_straight, "value", current, 0.45)
		_on_damage()
 
	elif is_heal:
		if front_tween and front_tween.is_running():
			front_tween.kill()
		if back_tween and back_tween.is_running():
			back_tween.kill()
 
		front_tween = create_tween().set_parallel()
		front_tween.tween_property(health_bar_straight, "value", current, 0.25)
		front_tween.tween_property(damage_bar_straight, "value",  current, 0.25)
		_on_heal()
 
	current_pct = pct
 
	if is_health:
		_check_low_hp_pulse(pct)
 
func _shake():
	var original_pos = position
	var tw = create_tween()
	tw.tween_property(self, "position", original_pos + Vector2(2, 0), 0.05)
	tw.tween_property(self, "position", original_pos - Vector2(2, 0), 0.05)
	tw.tween_property(self, "position", original_pos, 0.05)
 
func _flash(flash_color: Color):
	modulate = flash_color
	var t = create_tween()
	t.tween_property(self, "modulate", Color(1,1,1), 0.25)
 
func _on_damage():
	_flash(Color(1, 0.3, 0.3))
	if damage_shake:
		_shake()
 
func _on_heal():
	_flash(Color(0.3, 1, 0.3))
 
func _check_low_hp_pulse(pct: float) -> void:
	if pct < 0.25:
		if pulse_tween == null or not pulse_tween.is_running():
			if pulse_tween:
				pulse_tween.kill()
 
			pulse_tween = create_tween()
			pulse_tween.set_loops()
			pulse_tween.tween_property(self, "scale", Vector2(1.04, 1.04), 0.2)
			pulse_tween.tween_property(self, "scale", Vector2(1.00, 1.00), 0.2)
	else:
		scale = Vector2.ONE
 
		if pulse_tween and pulse_tween.is_running():
			pulse_tween.kill()
			pulse_tween = null
