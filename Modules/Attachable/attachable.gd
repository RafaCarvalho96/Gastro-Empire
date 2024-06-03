extends Node3D
class_name Attachable

@export var attachableMode: AttachableMode
@export var filter: bool = false
@export var categories: Array[AttachableCategories]

var slotPreload: PackedScene

enum AttachableCategories {UTENSIL, EMPTY_PLATE, PLATE, INGREDIENT}


func _ready():
	slotPreload = preload("res://Modules/Attachable/attachable_slot.tscn")
	for child in get_children():
		if child is AttachableSlot:
			addSlot(child.seqNumber,child)

func createSlot(seqNumber: int, position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ZERO):
	var slot = slotPreload.instantiate()
	add_child(slot)
	slot.seqNumber = seqNumber
	slot.position = Vector3.ZERO
	addSlot(seqNumber,slot)
	return slot


func addSlot(seqNumber: int, slot: AttachableSlot):
	attachableMode.addSlot(seqNumber,slot)


func removeSlot(seqNumber: int):
	attachableMode.removeSlot(seqNumber)


func clear():
	for slotNumber in attachableMode.slots.keys():
		removeSlot(slotNumber)


func getSlotWithIngredient(ingredientId: String) -> AttachableSlot:
	for slotNumber in attachableMode.attachedSlots:
		if getObject(slotNumber) is IngredientNode:
			var ingId: String = getObject(slotNumber).getResource().id
			if ingId == ingredientId:
				return attachableMode.slots[slotNumber]
	return null


func attach(object: Node3D, seqNumber: int = 0):
	if isObjectCategoryAllowed(object):
		attachableMode.attach(object,seqNumber)
		return true
	return false


func deattach(seqNumber: int = 0, clearNode: bool = false):
	attachableMode.deattach(seqNumber,clearNode)


func transfer(newAttachable: Attachable, seqNumber: int = 0, newSeqNumber: int = 0):
	attachableMode.transfer(newAttachable,seqNumber,newSeqNumber)


func getAttached():
	var slot = getAttachedSlot()
	if slot == null:
		return null
	return getObject(slot)


func getObject(seqNumber: int) -> Node3D:
	return attachableMode.getObject(seqNumber)


func hasAvaliableSlot() -> bool:
	return attachableMode.hasAvaliableSlot()


func hasAttachedSlot() -> bool:
	return attachableMode.hasAttachedSlot()


func isAvaliableSlot(slot: int):
	return attachableMode.isAvaliableSlot(slot)


func isAttachedSlot(slot: int):
	return attachableMode.isAttachedSlot(slot)


func getAttachedSlot():
	return attachableMode.getAttachedSlot()


func getAvaliableSlot():
	return attachableMode.getAvaliableSlot()


func isObjectCategoryAllowed(object: Node3D):
	if not filter:
		return true

	if object is Plate:
		if categories.has(AttachableCategories.PLATE):
			return true
		if categories.has(AttachableCategories.EMPTY_PLATE) and not object.attachable.hasAttachedSlot():
			return true

	if categories.has(AttachableCategories.INGREDIENT) and object is IngredientNode:
		return true
	
	if categories.has(AttachableCategories.UTENSIL) and (object is Stove or object is Dishrack or object is CuttingBoard):
		return true

	return false
