extends Node3D
class_name Fridge

@onready var fridge_gui = $FridgeGUI
@export var inv: Inventory

var isGuiOpen = false
var playerOpen: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_interact(player: Player):
	if player.attachable.hasObjectAttached:
		var object = player.attachable.getAttached()
		if not object is IngredientNode:
			openGui(player)
			return
		
		if not object.ingredientResource.hasAction(IngredientManager.CookingAction.FREEZE):
			openGui(player)
			return
		
		var amtReturned = inv.store(object.ingredientResource.id,1)
		if amtReturned == 0:
			player.attachable.deattachAndRemove()
		return
	else:
		openGui(player)


func _on_item_button_pressed(itemId: String):
	if playerOpen.attachable.hasObjectAttached:
		closeGui()
		return
	
	if not inv.remove(itemId,1):
		closeGui()
		return
		
	var item = IngredientManager.getIngredientNode(itemId)
	playerOpen.attachable.attach(item)
	closeGui()


func closeGui():
	isGuiOpen = false
	playerOpen = null
	fridge_gui.hide()


func openGui(player: Player):
	isGuiOpen = true
	playerOpen = player
	fridge_gui.show()
