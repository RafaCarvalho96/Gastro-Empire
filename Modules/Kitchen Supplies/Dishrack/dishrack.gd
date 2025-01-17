extends Utensil
class_name Dishrack

@export var attachable: Attachable
@onready var counter_2 = $"../Counter4"


var nextAttach: int = 1

func _ready():
	counter_2.attachable.attach(self)
	attachable.attach($Plate)
	attachable.attach($Plate2)


func _on_interact(player: Player):
	if player.attachable.hasAvaliableSlot() and hasPlate():
		getPlate(player.attachable, false)
		return
	elif player.attachable.hasAttachedSlot() and player.attachable.getAttached() is IngredientNode and player.attachable.getAttached().getResource().isPlateable and hasPlate():
		getPlate(player.attachable, true)
	elif not player.attachable.hasAvaliableSlot() and hasSlot():
		storePlate(player.attachable)
		return


func hasPlate() -> bool:
	return attachable.hasAttachedSlot()


func hasSlot() -> bool:
	return attachable.hasAvaliableSlot()


func getPlate(playerAttachable: Attachable, transferIngredient: bool):
	if not hasPlate():
		return
	
	var ingredientId: String
	if transferIngredient:
		ingredientId = playerAttachable.getAttached().getResource().id
		var plated = attachable.getAttached().plateIngredient(ingredientId)
		if not plated:
			return
		playerAttachable.deattach(0,true)
	attachable.transfer(playerAttachable)


func storePlate(playerAttachable: Attachable):
	if not hasSlot() or not attachable.isObjectCategoryAllowed(playerAttachable.getAttached()):
		return
	
	if playerAttachable.getAttached().attachable.hasAttachedSlot():
		return
	
	playerAttachable.transfer(attachable)
