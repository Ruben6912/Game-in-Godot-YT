extends Resource
class_name GunData

# --- Metadata ---
@export var gun_name: String = "Default Gun"

# Dropdown for gun categories, tiers 
@export_enum("Pistol", "Shotgun", "Rifle", "SMG", "Sniper") var gun_type: String = "Pistol"
@export var gun_level: int = 1
@export_enum("None","Fire","Poison","Ice","Electricity", "Wind", "Curse", "Blessing") var gun_debuff: String = "None"

# Optional icon (Sprite2D/Texture)
@export var icon: Texture2D

# --- Stats ---
@export var bullet_scene: PackedScene

@export var bullet_speed: float = 500.0
@export var bullet_lifetime: float = 1.5
@export var damage: int = 10

@export var reload_time: float = 1.0
@export var fire_rate: float = 0.2
@export var bullets_per_shot: int = 1
@export var spread_angle: float = 10.0
