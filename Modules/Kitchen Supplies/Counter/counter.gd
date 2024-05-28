class_name Counter extends Utensil

@export var attachable: Attachable


func _ready():
    pass

func _on_interact(player: Player):
    var obj = attachable.getAttached()
    if obj is CuttingBoard or obj is Stove or obj is Dishrack:
        return
    var player_attachable: Attachable = player.attachable
    if attachable.hasAttachedSlot() and player_attachable.hasAvaliableSlot():
        attachable.transfer(player_attachable)
        return
	 
    if attachable.hasAvaliableSlot() and player_attachable.hasAttachedSlot():
        player_attachable.transfer(attachable)
        return
	
    if not player_attachable.hasAvaliableSlot() and not attachable.hasAvaliableSlot():
        var playerObj: Node3D = player_attachable.getAttached()
        if playerObj is Plate and obj is IngredientNode:
            if obj.getResource().isPlateable and playerObj.attachable.hasAvaliableSlot():
                attachable.transfer(playerObj.attachable)
        if playerObj is IngredientNode and obj is Plate:
            if playerObj.getResource().isPlateable and obj.attachable.hasAvaliableSlot():
                player_attachable.transfer(obj.attachable)
