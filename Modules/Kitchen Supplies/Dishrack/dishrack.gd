extends Node3D
class_name Dishrack

@export var attachable1: Attachable
@export var attachable2: Attachable
@export var attachable3: Attachable
@export var attachable4: Attachable
@onready var counter_2 = $"../Counter4"


var nextAttach: int = 1

func _ready():
	counter_2.attachable.attach(self)
	attachable1.attach($Plate)
	attachable2.attach($Plate2)
	nextAttach = 3


func _on_interact(player: Player):
	if player.attachable.canAttach() and hasPlate():
		getPlate(player.attachable, false)
		return
	elif not player.attachable.canAttach() and player.attachable.getAttached() is IngredientNode and player.attachable.getAttached().ingredientResource.isPlateable and hasPlate():
		getPlate(player.attachable, true)
	elif not player.attachable.canAttach() and hasSlot():
		storePlate(player.attachable)
		return


func hasPlate() -> bool:
	return nextAttach > 1


func hasSlot() -> bool:
	return nextAttach <= 4


func getPlate(playerAttachable: Attachable, transferIngredient: bool):
	if not hasPlate():
		return
	
	var ingredient: IngredientNode
	if transferIngredient:
		ingredient = playerAttachable.getAttached()
		playerAttachable.deattach()
	
	if nextAttach == 2:
		attachable1.transfer(playerAttachable)
	elif nextAttach == 3:
		attachable2.transfer(playerAttachable)
	elif nextAttach == 4:
		attachable3.transfer(playerAttachable)
	elif nextAttach == 5:
		attachable4.transfer(playerAttachable)
	nextAttach -= 1
	
	if transferIngredient:
		playerAttachable.getAttached().attachable.attach(ingredient)


func storePlate(playerAttachable: Attachable):
	if not hasSlot() or not playerAttachable.getAttached() is Plate:
		return
	
	if playerAttachable.getAttached().attachableCount > 1 or not playerAttachable.getAttached().attachable.canAttach():
		return
	
	if nextAttach == 1:
		playerAttachable.transfer(attachable1)
	elif nextAttach == 2:
		playerAttachable.transfer(attachable2)
	elif nextAttach == 3:
		playerAttachable.transfer(attachable3)
	elif nextAttach == 4:
		playerAttachable.transfer(attachable4)
	nextAttach += 1
