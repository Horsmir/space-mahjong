extends Spatial


signal select_one

export var type_view = 1
export(NodePath) var piece_mesh_path


onready var over_mat = load("res://data/materials/OverPiece.material")
onready var piece_mesh = get_node(piece_mesh_path)


func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
    print(piece_mesh_path)
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            piece_mesh.material_override = over_mat
            emit_signal('select_one', self)
            

func clear_over_mat():
    piece_mesh.material_override = null
