extends AttachableMode
class_name ModeFixed

func attach(object: Node3D, seqNumber: int = 0):
    if not slots.has(seqNumber):
        return

    avaliableSlots.erase(seqNumber)
    attachedSlots.append(seqNumber)
    setObject(seqNumber,object)


func deattach(seqNumber: int = 0, clearNode: bool = false) -> Node3D:
    if not slots.has(seqNumber):
        return
    
    attachedSlots.erase(seqNumber)
    avaliableSlots.append(seqNumber)
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
    
    return attachedSlots.back()


func getAvaliableSlot():
    if not hasAvaliableSlot():
        return
    
    return avaliableSlots.back()