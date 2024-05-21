extends Resource
class_name Inventory

@export var maxStoredTypes: int = 1
@export var maxStoredAmount: int = 1
@export var content: Dictionary = {}

var storedAmount: int = 0

signal new_item(itemId: String, amount: int)
signal item_removed(itemId: String)
signal stock_changed(itemId: String, newAmount: int)

func has(itemId: String)-> bool:
	return content.has(itemId)


func getStock(itemId: String) -> int:
	if not has(itemId):
		return 0
	
	return content[itemId]


func remove(itemId: String, amount: int = 0) -> bool:
	if not has(itemId):
		return false
	
	if amount == 0 or amount == content[itemId]:
		content.erase(itemId)
		item_removed.emit(itemId)
		storedAmount -= amount
		return true
	
	if amount < getStock(itemId):
		content[itemId] -= amount
		storedAmount -= amount
		stock_changed.emit(itemId,content[itemId])
		return true
	
	return false


func removePartial(itemId: String, amount: int) -> int:
	if not has(itemId) or amount == 0:
		return 0
	
	if remove(itemId, amount):
		return amount
	
	var removedAmt = content[itemId]
	content.erase(itemId)
	storedAmount -= removedAmt
	item_removed.emit(itemId)
	return removedAmt


func store(itemId: String, amount: int) -> int:
	if storedAmount >= maxStoredAmount:
		return amount
	
	var freeAmount = maxStoredAmount - storedAmount
	var returnedAmount = amount - freeAmount
	if returnedAmount < 0:
		returnedAmount = 0
		
	var amountToStore = amount - returnedAmount
	
	if content.has(itemId):
		content[itemId] += amountToStore
		storedAmount += amountToStore
		stock_changed.emit(itemId,content[itemId])
	else:
		if content.keys().size() >= maxStoredTypes:
			return amount
		content[itemId] = amountToStore
		storedAmount += amountToStore
		new_item.emit(itemId,amountToStore)
	
	return returnedAmount
