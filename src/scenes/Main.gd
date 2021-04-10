extends Spatial


var check_1 = [false, null]
var check_2 = [false, null]


func _on_Piece_select_one(type_view):
    if check_1[0]:
        if not check_2[0]:
            check_2[0] = true
            check_2[1] = type_view
            check_pieces()
    else:
        check_1[0] = true
        check_1[1] = type_view            


func check_pieces():
    if check_1[0] and check_2[0]:
        if check_1[1].type_view == check_2[1].type_view:
            check_1[1].queue_free()
            check_2[1].queue_free()
            check_1 = [false, null]
            check_2 = [false, null]
            print('Ok')
        else:
            check_1[1].clear_over_mat()
            check_2[1].clear_over_mat()
            check_1 = [false, null]
            check_2 = [false, null]
            
