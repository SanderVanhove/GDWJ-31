extends Node2D

onready var _cooldown_timer: Timer = $ItemCooldown

func _ready():
	for i in range(1, 5):
		for slot in slot(i):
			change_slot_alpha(slot, 0.5)
			$item_anim.start()

func _input(event):
	if Input.is_action_just_pressed("inventory_keys"):
		var new_selected: int = 0
		match  event.scancode:
			KEY_1:
				new_selected = 1
				_cooldown_timer.start()
			KEY_2:
				new_selected = 2
				_cooldown_timer.start()
			KEY_3:
				new_selected = 3
			KEY_4:
				new_selected = 4
		gg.selected = new_selected if new_selected != gg.selected else 0

		for i in range(1, 5):
			if i != gg.selected:
				for slot in slot(i):
					change_slot_alpha(slot, 0.7)
			else:
				for slot in slot(i):
					change_slot_alpha(slot, 1)
		$item_anim.start()

func change_slot_alpha(slot: Node, alpha: float) -> void:
	$item_anim.interpolate_property(slot,
									"modulate:a",
									slot.modulate.a,
									alpha,
									0.4,
									Tween.TRANS_BACK,
									Tween.EASE_OUT)

func slot(key: int):
	var items = ["cactus", "skateboard", "blowdryer", "magnet"]
	# uncomment when backgrounds for the slots exist
	return [get_node("backgrounds/TextureRect" + String(key)), get_node("backgrounds/text_" + String(key)), get_node("items/" + items[key - 1])]
#	return [get_node("backgrounds/text_" + String(key)), get_node("items/" + items[key])]


func _on_ItemCooldown_timeout() -> void:
	if gg.selected == 1 or gg.selected == 2:
		for slot in slot(gg.selected):
			change_slot_alpha(slot, 0.7)
		$item_anim.start()
		gg.selected = 0
