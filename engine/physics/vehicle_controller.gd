extends VehicleBody3D
class_name VehicleController
## Arcade-but-grounded vehicle dynamics. Keyboard + gamepad.
## Tune mass, power, grip per vehicle in the inspector.

@export var max_engine_force: float = 3500.0
@export var max_brake_force: float = 6000.0
@export var max_steering_angle: float = 0.45
@export var steering_speed: float = 3.5

var _steer_input: float = 0.0
var _throttle: float = 0.0
var _brake: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		_handle_joypad(event)
	elif event.is_action_pressed("throttle") or event.is_action_released("throttle"):
		_throttle = 1.0 if event.is_action_pressed("throttle") else 0.0
	elif event.is_action_pressed("brake") or event.is_action_released("brake"):
		_brake = 1.0 if event.is_action_pressed("brake") else 0.0
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_steer_input = clampf(_steer_input - event.relative.x * 0.002, -1.0, 1.0)

func _handle_joypad(event: InputEventJoypadMotion) -> void:
	if event.axis == JOY_AXIS_LEFT_X:
		_steer_input = event.axis
	elif event.axis == JOY_AXIS_TRIGGER_RIGHT:
		_throttle = event.axis
	elif event.axis == JOY_AXIS_TRIGGER_LEFT:
		_brake = event.axis

func _physics_process(delta: float) -> void:
	steering = lerp(steering, _steer_input * max_steering_angle, steering_speed * delta)
	engine_force = _throttle * max_engine_force
	brake = _brake * max_brake_force
	_apply_drift_assist(delta)

func _apply_drift_assist(delta: float) -> void:
	# Kill lateral slide above a threshold so arcade handling stays planted.
	var lateral := global_transform.basis.x.dot(linear_velocity)
	if absf(lateral) > 8.0:
		linear_velocity -= global_transform.basis.x * lateral * 0.6 * delta
