extends CharacterBody3D

@export var speed: float = 7
@export var jump_force: float = 5
@export var sensibilidad_mouse: float = 0.002

@onready var camera: Camera3D = $Camera3D

var pitch: float = 0.0
var gravedad = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * sensibilidad_mouse)

		pitch -= event.relative.y * sensibilidad_mouse
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		camera.rotation.x = pitch

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta

	if Input.is_action_just_pressed("Salto") and is_on_floor():
		velocity.y = jump_force

	var input_dir := Vector2.ZERO

	if Input.is_action_pressed("mover_derecha"):
		input_dir.x += 1
	if Input.is_action_pressed("mover_izquierda"):
		input_dir.x -= 1
	if Input.is_action_pressed("mover_adelante"):
		input_dir.y -= 1
	if Input.is_action_pressed("mover_atras"):
		input_dir.y += 1

	input_dir = input_dir.normalized()

	var direccion = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direccion != Vector3.ZERO:
		velocity.x = direccion.x * speed
		velocity.z = direccion.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
