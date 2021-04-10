extends Node


var schema = 'a'
var piece_dicts = []
var deck = []
var place_array

var start_pos = Vector3(-2.0, 0.0, -1.55)
var piece_width = 0.25
var piece_height = 0.38
var piece_deep = 0.19

var circuite_file = 'res://data/circuites/ex_01.json'
var piece_list = []
var deck_shufle = []


func _ready():
    randomize()
    for i in range(42):
        var d = {}
        if i >= 16 and i < 20:
            d['view_type'] = 17
        elif i >= 20 and i < 24:
            d['view_type'] = 20
        else:
            d['view_type'] = i+1
        if (i + 1) < 10:
            d['mesh_path'] = 'res://src/objects/pieces-{0}/Piece_0{1}{0}.tscn'.format([schema, i+1])
        else:
            d['mesh_path'] = 'res://src/objects/pieces-{0}/Piece_{1}{0}.tscn'.format([schema, i+1])
        piece_dicts.append(d)

    for i in range(16):
        for j in range(4):
            deck.append(piece_dicts[i])
    for i in range(16, 24):
        deck.append(piece_dicts[i])
    for i in range(24, 42):
        for j in range(4):
            deck.append(piece_dicts[i])

    parse_circ()
    calculation_coords()
    deck_shufle = deck
    deck_shufle.shuffle()


func parse_circ():
    var file = File.new()
    file.open(circuite_file, File.READ)
    var content = file.get_as_text()
    file.close()

    var res = JSON.parse(content)
    place_array = res.result

    var fg = false
    for j in range(len(place_array)):
        var tmp = {}
        for k in range(len(place_array[j])):
            tmp[k+1] = []
            for i in range(len(place_array[j][k])):
                var n = place_array[j][k][i]
                if n == 0 or fg:
                    fg = false
                    continue
                if n == 1:
                    if k > 0:
                        if i in tmp[k]:
                            continue
                    var d = {'level': j, 'str_1': k, 'str_2': k+1, 'id_1': i, 'id_2': i+1}
                    tmp[k+1].append(i)
                    tmp[k+1].append(i+1)
                    piece_list.append(d)
                    fg = true


func calculation_coords():
    var hw = piece_width / 2
    var hh = piece_height / 2

    for d in piece_list:
        var x = d['id_1'] * hw + hw
        var z = d['str_1'] * hh + hh
        var y = d['level'] * piece_deep
        d['pos'] = Vector3(x, y, z) + start_pos
