extends CanvasLayer
class_name FridgeGUI

@export var fridge: Fridge
@export var buttonScene: PackedScene

@onready var grid_container = $PanelContainer/VBoxContainer/MarginContainer/GridContainer

var slots: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	fridge.inv.new_item.connect(_on_new_item)
	fridge.inv.item_removed.connect(_on_item_removed)
	fridge.inv.stock_changed.connect(_on_stock_changed)
	hide()
	for i in fridge.inv.content:
		var btn: FridgeGUIItem = buttonScene.instantiate()
		btn.setIngredientId(i)
		btn.setTitle(IngredientManager.ingredients[i].name)
		btn.setQuantity(fridge.inv.getStock(i))
		btn.button.pressed.connect(fridge._on_item_button_pressed.bind(i))
		grid_container.add_child(btn)
		slots[i] = btn


func _on_new_item(itemId: String, stock: int):
	var btn: FridgeGUIItem = buttonScene.instantiate()
	btn.setIngredientId(itemId)
	btn.setTitle(IngredientManager.ingredients[itemId].name)
	btn.setQuantity(fridge.inv.getStock(itemId))
	btn.button.pressed.connect(fridge._on_item_button_pressed.bind(itemId))
	grid_container.add_child(btn)
	slots[itemId] = btn


func _on_item_removed(itemId: String):
	slots[itemId].queue_free()
	slots.erase(itemId)


func _on_stock_changed(itemId: String, newStock: int):
	var btn: FridgeGUIItem = slots[itemId]
	btn.setQuantity(newStock)


func _on_button_pressed():
	fridge.isGuiOpen = false
	hide()
