extends Resource
class_name AttachableMode

var slots: Dictionary = {}
var avaliableSlots: Array[int] = []
var attachedSlots: Array[int] = []

func addSlot(seqNumber: int, slot: AttachableSlot):
	slots[seqNumber] = slot
	if slot.object == null:
		avaliableSlots.append(seqNumber)
		avaliableSlots.sort()
	else:
		attachedSlots.append(seqNumber)
		avaliableSlots.sort()


func removeSlot(seqNumber: int):
	if slots.has(seqNumber):
		slots[seqNumber].queue_free()
		slots.erase(seqNumber)
	
	if avaliableSlots.has(seqNumber):
		avaliableSlots.erase(seqNumber)
	
	if attachedSlots.has(seqNumber):
		attachedSlots.erase(seqNumber)


func getObject(seqNumber: int) -> Node3D:
	return slots[seqNumber].object


func setObject(seqNumber: int, object: Node3D):
	var slot: AttachableSlot = slots[seqNumber]
	slot.object = object

	if object == null:
		return

	if object.is_inside_tree():
		object.reparent.call_deferred(slot)
	else:
		slot.add_child(object)

	object.position = Vector3.ZERO
	object.global_position = slot.global_position
	object.global_rotation = slot.global_rotation


# func attach(_object: Node3D, _seqNumber: int = 0):
#     pass


# func deattach(_seqNumber: int = 0, _clearNode: bool = false):
#     pass


# func transfer(_newAttachable: Attachable, _seqNumber: int = 0, _newSeqNumber: int = 0):
#     pass


# func hasAvaliableSlot():
#     pass


# func hasAttachedSlot():
#     pass


# func isAvaliableSlot(_slot: int):
#     pass


# func isAttachedSlot(_slot: int):
#     pass


# func getAttachedSlot():
#     pass


# func getAvaliableSlot():
#     pass
