extends Utensil
class_name Fridge

@onready var fridge_gui = $FridgeGUI
@export var inv: Inventory

var isGuiOpen = false
var playerOpen: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_interact(player: Player):
	var playerAttachable: Attachable = player.attachable
	if playerAttachable.hasAttachedSlot():
		var object = playerAttachable.getAttached()
		
		if object is Plate and object.attachable.hasAttachedSlot():
			object = object.attachable.getAttached()

		if object == null or not object is IngredientNode:
			openGui(player)
			return
		
		if not object.getResource().hasAction(IngredientManager.CookingAction.FREEZE):
			openGui(player)
			return
		
		var amtReturned = inv.store(object.getResource().id,1)
		if amtReturned == 0:
			if playerAttachable.getAttached() is Plate:
				playerAttachable.getAttached().attachable.deattach(0, true)
			else:
				playerAttachable.deattach(0, true)
		return
	else:
		openGui(player)


func _on_item_button_pressed(itemId: String):
	var plate: Plate = null
	if playerOpen.attachable.getAttached() is Plate:
		plate = playerOpen.attachable.getAttached()

	if not playerOpen.attachable.hasAvaliableSlot() and plate == null:
		closeGui()
		return
	
	if plate != null and not plate.isIngredientAllowed(itemId):
		closeGui()
		return
	
	if not inv.remove(itemId,1):
		closeGui()
		return
		
	var item = IngredientManager.getIngredientNode(itemId)
	if plate != null:
		plate.attachable.attach(item)
	else:
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
