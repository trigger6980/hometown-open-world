extends Node
class_name DayNightCycle
## Drives sun position, ambient light, and shadow cascades from game time.
## 24 in-game minutes per real second by default (1 in-game day ≈ 40 real min).

@export var sun: DirectionalLight3D
@export var world_environment: WorldEnvironment
@export var minutes_per_real_second: float = 24.0

var game_minutes: float = 8.0 * 60.0  # start at 8 AM

func _process(delta: float) -> void:
	game_minutes = fmod(game_minutes + delta * minutes_per_real_second, 24.0 * 60.0)
	_update_sun()
	_update_ambient()

func _update_sun() -> void:
	if sun == null:
		return
	var t := game_minutes / (24.0 * 60.0)
	var angle := (t - 0.25) * TAU
	sun.rotation = Vector3(angle, 0.0, 0.0)
	var night := clampf(1.0 - smoothstep(0.2, 0.3, t) + smoothstep(0.7, 0.8, t), 0.0, 1.0)
	sun.light_energy = lerpf(1.0, 0.05, night)

func _update_ambient() -> void:
	if world_environment == null or world_environment.environment == null:
		return
	var t := game_minutes / (24.0 * 60.0)
	var night := clampf(smoothstep(0.75, 0.85, t), 0.0, 1.0)
	world_environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY if night < 0.5 else Environment.AMBIENT_SOURCE_COLOR
	world_environment.environment.ambient_light_color = Color(0.15, 0.18, 0.25) if night > 0.5 else Color(0.6, 0.65, 0.7)
