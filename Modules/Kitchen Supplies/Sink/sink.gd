class_name Sink extends Node3D

@onready var attachable: Attachable = $Attachable

func _ready():
	attachable.attach(IngredientManager.getIngredientNode("tomato"))

func _on_interact(player: Player):
	var player_attachable: Attachable = player.get_meta("attachable")
	if attachable.hasObjectAttached and not player_attachable.hasObjectAttached:
		attachable.transfer(player_attachable)
		return
	 
	if not attachable.hasObjectAttached and player_attachable.hasObjectAttached:
		player_attachable.transfer(attachable)
		return
	
	if not player.attachable.canAttach() and not attachable.canAttach() and player.attachable.getAttached() is Plate:
		if attachable.getAttached().ingredientResource.isPlateable and player.attachable.getAttached().attachable.canAttach():
			attachable.transfer(player.attachable.getAttached().attachable)

