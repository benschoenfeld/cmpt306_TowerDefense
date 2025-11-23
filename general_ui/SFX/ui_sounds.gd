## @tutorial link https://www.youtube.com/watch?v=QgBecUl_lFs&list=LL&index=8&t=1304s
## scans the scene to connect signals from UI to SFX
extends Node

## The root node where the script will search for UI nodes.
@export var root_path: NodePath

## Audio players
@onready var sounds = {
	&"UI_Click" : AudioStreamPlayer.new(),
	&"UI_Hover" : AudioStreamPlayer.new(),
}

func _ready() -> void:
	assert(root_path != null,  "Empty root path for UI sounds")
	# load sound files
	for i in sounds.keys():
		sounds[i].stream = load("res://general_ui/SFX/" + str(i) + ".ogg")
		# assign UI sounds to SFX bus
		sounds[i].bus = &"SFX"
		# add to scene tree
		add_child(sounds[i])
	# connect signal to method that plays sounds
	install_sounds(get_node(root_path))

## Looks through the tree and finds [Button] nodes. Then connects functions
## of the buttons to play sounds.
func install_sounds(node: Node) -> void:
	for i in node.get_children():
		if i is Button:
			# hover and click sounds for buttons
			i.mouse_entered.connect( func(): ui_sfx_play(&"UI_Hover") )
			i.pressed.connect( func(): ui_sfx_play(&"UI_Click") )
		install_sounds(i)

## Play sounds when a [Button] is hit.
func ui_sfx_play(sound: StringName) -> void:
	sounds[sound].play()
