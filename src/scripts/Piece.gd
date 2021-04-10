extends Spatial


signal select_one(mesh)

var piece_mesh_scene setget set_piece_scene

var piece_mesh = null
var type_view = 1
var place_data
var blocked = true

var mesh_material = null

onready var anim_play = $AnimationPlayer
onready var over_mat = load("res://data/materials/PieceAOver.material")


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            emit_signal('select_one', self)


func set_anim():
    $Area/CollisionShape.set_deferred('disabled', true)
    anim_play.play('selected')


func set_piece_scene(scene):
    piece_mesh_scene = scene
    piece_mesh = load(piece_mesh_scene).instance()
    $Mesh.add_child(piece_mesh)


func set_back_anim():
    $Area/CollisionShape.set_deferred('disabled', false)
    anim_play.play_backwards('selected')


func check_blocked():
    var lt = 0
    var lb = 0
    var rt = 0
    var rb = 0
    var ult = 0
    var ulb = 0
    var urt = 0
    var urb = 0

    if place_data['id_1'] > 0:
        lt = GD.place_array[place_data['level']][place_data['str_1']][place_data['id_1']-1]
        lb = GD.place_array[place_data['level']][place_data['str_2']][place_data['id_1']-1]
    if place_data['id_2'] < len(GD.place_array[place_data['level']][place_data['str_1']]) - 1:
        rt = GD.place_array[place_data['level']][place_data['str_1']][place_data['id_2']+1]
        rb = GD.place_array[place_data['level']][place_data['str_2']][place_data['id_2']+1]
    if place_data['level'] < len(GD.place_array) - 1:
        ult = GD.place_array[place_data['level']+1][place_data['str_1']][place_data['id_1']]
        ulb = GD.place_array[place_data['level']+1][place_data['str_2']][place_data['id_1']]
        urt = GD.place_array[place_data['level']+1][place_data['str_1']][place_data['id_2']]
        urb = GD.place_array[place_data['level']+1][place_data['str_2']][place_data['id_2']]

    blocked = ult or ulb or urt or urb
    if not blocked:
        blocked = lt or lb
        if blocked:
            blocked = rt or rb
    return blocked


func clear_place_array():
    GD.place_array[place_data['level']][place_data['str_1']][place_data['id_1']] = 0
    GD.place_array[place_data['level']][place_data['str_1']][place_data['id_2']] = 0
    GD.place_array[place_data['level']][place_data['str_2']][place_data['id_1']] = 0
    GD.place_array[place_data['level']][place_data['str_2']][place_data['id_2']] = 0


func over_material(on):
    if on:
        piece_mesh.get_child(0).material_override = over_mat
    else:
        piece_mesh.get_child(0).material_override = null
