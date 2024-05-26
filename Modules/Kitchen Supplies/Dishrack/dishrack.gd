extends Node3D
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
	elif not player.attachable.hasAvaliableSlot() and player.attachable.getAttached() is IngredientNode and player.attachable.getAttached().getResource().isPlateable and hasPlate():
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
	
	var ingredient: IngredientNode
	if transferIngredient:
		ingredient = playerAttachable.getAttached()
		playerAttachable.deattach()
	
	attachable.transfer(playerAttachable)
	
	if transferIngredient:
		playerAttachable.getAttached().attachable.attach(ingredient)


func storePlate(playerAttachable: Attachable):
	if not hasSlot() or not playerAttachable.getAttached() is Plate:
		return
	
	if playerAttachable.getAttached().attachable.hasAttachedSlot():
		return
	
	playerAttachable.transfer(attachable)
