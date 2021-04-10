extends Spatial


export(PackedScene) var piece_scene

var check_1 = [false, null]
var check_2 = [false, null]

var hint_pieces = []

export var score_one = 5
var time_score = 5.0
var s_time = 0.0


func generate_scene():
    for i in range(len(GD.deck_shufle)):
        var ps = piece_scene.instance()
        ps.piece_mesh_scene = GD.deck_shufle[i]['mesh_path']
        ps.type_view = GD.deck_shufle[i]['view_type']
        ps.place_data = GD.piece_list[i]
        ps.translation = GD.piece_list[i]['pos']
        ps.connect('select_one', self, 'on_select_piece')
        $Pieces.add_child(ps)


func _ready():
    generate_scene()


func on_select_piece(piece):
    if not hint_pieces.empty():
        hint_pieces[0].over_material(false)
        hint_pieces[1].over_material(false)
        hint_pieces.clear()
    if piece.check_blocked():
        if check_1[0]:
            check_1[1].set_back_anim()
            check_1 = [false, null]
        return
    piece.set_anim()
    yield(piece.get_node('AnimationPlayer'), 'animation_finished')
    piece_select_one(piece)


func piece_select_one(cur_piece):
    if check_1[0]:
        if not check_2[0]:
            check_2[0] = true
            check_2[1] = cur_piece
            check_pieces()
    else:
        check_1[0] = true
        check_1[1] = cur_piece


func check_pieces():
    if check_1[0] and check_2[0]:
        if check_1[1].type_view == check_2[1].type_view:
            check_1[1].clear_place_array()
            check_2[1].clear_place_array()
            check_1[1].queue_free()
            check_2[1].queue_free()
            check_1 = [false, null]
            check_2 = [false, null]
            G.score += int(score_one * time_score / s_time)
            s_time = 0
            print(G.score)
        else:
            check_1[1].set_back_anim()
            check_2[1].set_back_anim()
            check_1 = [false, null]
            check_2 = [false, null]


func check_equal():
    var ph = []
    var p = $Pieces.get_children()
    for pi in p:
        if not pi.check_blocked():
            ph.append(pi)
    if ph.size() != 0:
        for i in range(ph.size()):
            for j in range(ph.size()):
                if j == i:
                    continue
                if ph[j].type_view == ph[i].type_view:
                    hint_pieces.append(ph[i])
                    hint_pieces.append(ph[j])
                    hint_pieces[0].over_material(true)
                    hint_pieces[1].over_material(true)
                    return true
    return false


func piece_shufle():
    var p = $Pieces.get_children()
    var pd = []
    for pi in p:
        pd.append(pi.place_data)
    pd.shuffle()
    for i in p.size():
        p[i].place_data = pd[i]
        p[i].translation = pd[i]['pos']


# func _input(event):
#     if event.is_action_pressed('get_hint'):
#         check_equal()
#     if event.is_action_pressed('shufle'):
#         piece_shufle()


func _process(delta):
    if Input.is_action_just_pressed('get_hint'):
        check_equal()
    if Input.is_action_just_pressed('shufle'):
        piece_shufle()

    s_time += delta
