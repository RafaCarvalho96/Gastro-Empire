class_name Crate extends Node3D

@export var ingredient: Ingredient

func _on_interact(player: Player):
	if not player.attachable.canAttach():
		if player.attachable.getAttached() is IngredientNode:
			if player.attachable.getAttached().getResource().id == ingredient.id:
				player.attachable.deattachAndRemove()
		return
	
	var ingrObject = IngredientManager.getIngredientNode(ingredient.id)
	player.attachable.attach(ingrObject)
