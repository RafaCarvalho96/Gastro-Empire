class_name Counter extends Node3D

@onready var attachable: Attachable = $Attachable


func _ready():
	pass

func _on_interact(player: Player):
	if attachable.getAttached() is CuttingBoard or attachable.getAttached() is Stove or attachable.getAttached() is Dishrack:
		return
	var player_attachable: Attachable = player.get_meta("attachable")
	if not attachable.canAttach() and player_attachable.canAttach():
		attachable.transfer(player_attachable)
		return
	 
	if attachable.canAttach() and not player_attachable.canAttach():
		player_attachable.transfer(attachable)
		return
	
	if not player_attachable.canAttach() and not attachable.canAttach():
		if player_attachable.getAttached() is Plate and attachable.getAttached() is IngredientNode:
			if attachable.getAttached().ingredientResource.isPlateable and player_attachable.getAttached().attachable.canAttach():
				attachable.transfer(player_attachable.getAttached().attachable)
		if player_attachable.getAttached() is IngredientNode and attachable.getAttached() is Plate:
			if player_attachable.getAttached().ingredientResource.isPlateable and attachable.getAttached().attachable.canAttach():
				player_attachable.transfer(attachable.getAttached().attachable)
