extends Resource
class_name PlayerData

@export var steam_user_name: String
@export_enum("Test", "Test2") var character: String = "Test"
@export_enum("player", "enemy", "neutral") var character_team_id: String = "Test"
@export var max_health: int = 3
@export var health: int = max_health
@export var defense: int = 0
@export var max_speed: float
@export var speed: float
@export var dashSpeed: float
@export var is_dashing: bool
@export var is_disabled: bool
var last_direction: Vector2 = Vector2.RIGHT
