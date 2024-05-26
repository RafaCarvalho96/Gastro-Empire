class_name Crate extends Node3D

@export var ingredient: Ingredient

func _on_interact(player: Player):
	var playerAttachable: Attachable = player.attachable
	if playerAttachable.hasAttachedSlot():
		var object: Node3D = playerAttachable.getObject(playerAttachable.getAttachedSlot())
		if object is IngredientNode:
			if object.getResource().id == ingredient.id:
				player.attachable.deattach(0,true)
		return
	
	var ingrObject = IngredientManager.getIngredientNode(ingredient.id)
	player.attachable.attach(ingrObject)
