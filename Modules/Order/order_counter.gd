extends Node3D
class_name OrderCounter

func _on_interact(player:Player):
    if not player.attachable.getAttached() is Plate:
        return
    
    var plate:Plate = player.attachable.getAttached()
    if not plate.isFinishedPlate or not plate.finishedPlate.isOrederable:
        return

    OrderManager.deliverPlate(plate.finishedPlate.id)