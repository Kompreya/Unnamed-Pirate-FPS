@icon("res://addons/plenticons/icons/16x/creatures/heart-half-green.png")

extends Sprite3D

func update_hp(cur_hp, max_hp):
	$SubViewport/HPBar3D.max_value = max_hp
	$SubViewport/HPBar3D.value = cur_hp
	$SubViewport/HPBar3D/HP.text = str(cur_hp) + "/" + str(max_hp)
