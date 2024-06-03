extends AttachableMode
class_name ModeQueue

func attach(object: Node3D, seqNumber: int = 0):
	if avaliableSlots.size() == 0:
		return
	
	seqNumber = avaliableSlots.pop_front()
	attachedSlots.push_back(seqNumber)
	setObject(seqNumber,object)


func deattach(seqNumber: int = 0, clearNode: bool = false) -> Node3D:
	if attachedSlots.size() == 0:
		return null
	
	seqNumber = attachedSlots.pop_front()
	avaliableSlots.push_back(seqNumber)
	var obj = getObject(seqNumber)
	if clearNode:
		obj.queue_free()
		setObject(seqNumber,null)
		return null
	
	return obj


func transfer(newAttachable: Attachable, seqNumber: int = 0, newSeqNumber: int = 0):
	var obj = deattach(seqNumber)
	if obj == null:
		return
	if not newAttachable.attach(obj, newSeqNumber):
		attach(obj,seqNumber)


func hasAvaliableSlot() -> bool:
	return avaliableSlots.size() > 0


func hasAttachedSlot() -> bool:
	return attachedSlots.size() > 0


func isAvaliableSlot(slot: int):
	return avaliableSlots.has(slot)


func isAttachedSlot(slot: int):
	return attachedSlots.has(slot)


func getAttachedSlot():
	if not hasAttachedSlot():
		return
	
	return attachedSlots.front()


func getAvaliableSlot():
	if not hasAvaliableSlot():
		return
	
	return avaliableSlots.front()
