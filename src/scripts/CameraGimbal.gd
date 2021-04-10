extends Spatial


# Настройки мыши
export (bool) var invert_y = false
export (bool) var invert_x = false
var mouse_control = false
export (float, 0.001, 0.1) var mouse_sensitivity = 0.05

# Настройка приближения/удаления
export (float) var max_zoom = 3.0
export (float) var min_zoom = 0.5
export (float, 0.05, 1.0) var zoom_speed = 0.09

var zoom = 1.0


func _unhandled_input(event):
    if event.is_action_pressed("cam_zoom_in"):
        zoom -= zoom_speed
    if event.is_action_pressed("cam_zoom_out"):
        zoom += zoom_speed
    zoom = clamp(zoom, min_zoom, max_zoom)

    if event.is_action_pressed('cam_move'):
        mouse_control = true
    if event.is_action_released('cam_move'):
        mouse_control = false

    if event.is_action_pressed('cam_center'):
        to_center()

    if mouse_control and event is InputEventMouseMotion:
        if event.relative.x != 0:
            var dir = 1 if invert_x else -1
            rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
        if event.relative.y != 0:
            var dir = 1 if invert_y else -1
            var y_rotation = clamp(event.relative.y, -30, 30)
            $InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)


func _process(delta):
    $InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -PI/2, -0.01)
    scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)


func to_center():
    rotation = Vector3.ZERO
    $InnerGimbal.rotation = Vector3(-PI/2, 0.0, 0.0)
    zoom = 1.0
