extends Control

var is_open: bool = false
@onready var shop_msg: Label = $Panel/ShopMessage

func _ready() -> void:
	close()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shop"):
		if is_open:
			close()
		else:
			open()

func open() -> void:
	visible = true
	is_open = true
	print("shop_opened")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close() -> void:
	visible = false
	is_open = false
	print("shop_closed")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_sell_weapon_purchase_succeed() -> void:
	shop_msg.text = "Blundershark Purchased! Press 2 to switch."


func _on_sell_weapon_purchase_failed() -> void:
	shop_msg.text = "Not enough treasure!"
