class_name Sink extends Utensil

@export var attachable: Attachable


func _ready():
	pass


func _on_interact(player: Player):
	var player_attachable: Attachable = player.attachable
	if attachable.hasAttachedSlot() and player_attachable.hasAvaliableSlot():
		attachable.transfer(player_attachable)
		return
	 
	if attachable.hasAvaliableSlot() and player_attachable.hasAttachedSlot():
		player_attachable.transfer(attachable)
		return
		
	if attachable.hasAttachedSlot():
		if attachable.getAttached() is Plate:
			if player_attachable.hasAttachedSlot() and player_attachable.getAttached() is IngredientNode:
				attachable.getAttached().plate(player_attachable)
		elif attachable.getAttached() is IngredientNode:
			if player_attachable.hasAttachedSlot() and player_attachable.getAttached() is Plate:
				player_attachable.getAttached().plate(attachable)

