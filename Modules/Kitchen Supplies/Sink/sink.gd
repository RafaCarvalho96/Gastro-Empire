class_name Sink extends Utensil

@export var attachable: Attachable


func _ready():
	pass


func _on_interact(player: Player):
	var player_attachable: Attachable = player.attachable
	if not attachable.hasAvaliableSlot() and player_attachable.hasAvaliableSlot():
		attachable.transfer(player_attachable)
		return
	 
	if attachable.hasAvaliableSlot() and player_attachable.hasAttachedSlot():
		player_attachable.transfer(attachable)
		return
	
	if not player_attachable.hasAvaliableSlot() and not attachable.hasAvaliableSlot() and player_attachable.getAttached() is Plate:
		if attachable.getAttached().getResource().isPlateable and player_attachable.getAttached().attachable.hasAvaliableSlot():
			attachable.transfer(player_attachable.getAttached().attachable)

