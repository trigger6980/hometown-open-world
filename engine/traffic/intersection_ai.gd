extends Node
class_name IntersectionAI
## NPC vehicle controller at intersections.
## Handles stop, yield, signal priority. One instance per controlled vehicle.

enum State { CRUISING, STOPPING, WAITING, GOING }

@export var vehicle: VehicleBody3D
@export var sensors: Array[RayCast3D] = []

var state: State = State.CRUISING
var _stop_line_distance: float = INF
var _clear_timer: float = 0.0

func _physics_process(delta: float) -> void:
	match state:
		State.CRUISING:
			_scan_ahead()
		State.STOPPING:
			_brake(delta)
		State.WAITING:
			_clear_timer -= delta
			if _is_clear() and _clear_timer <= 0.0:
				state = State.GOING
		State.GOING:
			_accelerate(delta)
			if _past_intersection():
				state = State.CRUISING

func _scan_ahead() -> void:
	for sensor in sensors:
		if sensor.is_colliding():
			var collider := sensor.get_collider()
			if collider is StopLine:
				_stop_line_distance = sensor.global_position.distance_to(collider.global_position)
				if _stop_line_distance < 12.0:
					state = State.STOPPING
				break

func _brake(delta: float) -> void:
	vehicle.engine_force = lerp(vehicle.engine_force, -800.0, delta * 4.0)
	if vehicle.linear_velocity.length() < 0.5:
		vehicle.engine_force = 0.0
		state = State.WAITING
		_clear_timer = randf_range(0.5, 2.0)

func _is_clear() -> bool:
	for sensor in sensors:
		if sensor.is_colliding() and sensor.get_collider() is VehicleBody3D:
			return false
	return true

func _accelerate(delta: float) -> void:
	vehicle.engine_force = lerp(vehicle.engine_force, 1200.0, delta * 2.0)

func _past_intersection() -> bool:
	return _stop_line_distance == INF
