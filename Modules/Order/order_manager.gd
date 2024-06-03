extends Node

var orderablePlates: Dictionary = {}
var activeOrders: Dictionary = {}

func _ready():
	for finishedPlate: FinishedPlate in RecipeManager.finishedPlates.values():
		if finishedPlate.isOrderable:
			orderablePlates[finishedPlate.id] = finishedPlate


func placeOrder():
	pass


func deliverPlate(plateId: String):
	pass