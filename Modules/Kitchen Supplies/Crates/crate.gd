class_name Crate extends Utensil

@export var ingredient: Ingredient

func _on_interact(player: Player):
	var playerAttachable: Attachable = player.attachable
	if playerAttachable.hasAttachedSlot():
		var object: Node3D = playerAttachable.getAttached()
		if object is IngredientNode:
			if object.getResource().id == ingredient.id:
				player.attachable.deattach(0,true)
		elif object is Plate and ingredient.isPlateable:
			object.plateIngredient(ingredient.id)
		return
	
	var ingrObject = IngredientManager.getIngredientNode(ingredient.id)
	player.attachable.attach(ingrObject)
