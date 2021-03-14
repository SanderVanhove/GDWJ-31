extends Node2D

func _ready():
	for i in range(1, 5):
		for slot in slot(i):
			$item_anim.interpolate_property(slot,
											"modulate",
											slot.modulate,
											Color(slot.modulate.r, slot.modulate.g, slot.modulate.b, 0.5),
											0.4,
											Tween.TRANS_BACK,
											Tween.EASE_OUT)
			$item_anim.start()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		match  event.scancode:
			KEY_1:
				gg.selected = 1
			KEY_2:
				gg.selected = 2
			KEY_3:
				gg.selected = 3
			KEY_4:
				gg.selected = 4
		for i in range(1, 5):
			if i != gg.selected:
				for slot in slot(i):
					$item_anim.interpolate_property(slot,
													"modulate",
													slot.modulate,
													Color(slot.modulate.r, slot.modulate.g, slot.modulate.b, 0.5),
													0.4,
													Tween.TRANS_BACK,
													Tween.EASE_OUT)
			else:
				for slot in slot(i):
					$item_anim.interpolate_property(slot,
													"modulate",
													slot.modulate,
													Color(slot.modulate.r, slot.modulate.g, slot.modulate.b, 1),
													0.4,
													Tween.TRANS_BACK,
													Tween.EASE_OUT)
		$item_anim.start()

func slot(key: int):
	var items = ["cactus", "skateboard", "blowdryer", "magnet"]
	# uncomment when backgrounds for the slots exist
	return [get_node("backgrounds/TextureRect" + String(key)), get_node("backgrounds/text_" + String(key)), get_node("items/" + items[key - 1])]
#	return [get_node("backgrounds/text_" + String(key)), get_node("items/" + items[key])]
