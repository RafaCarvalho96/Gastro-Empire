class_name AttachablePoint extends Marker3D

@export var seqNumber: int = 0
@export var categories: Array[Attachable.ObjectCategories]

var hasObjectAttached: bool = false
var object: Node3D


signal attached_point(object: Node3D,pointSeq: int)
signal deattached_point(object: Node3D,pointSeq: int)


func canAttach() -> bool:
    return not hasObjectAttached


func hasObject() -> bool:
    return hasObjectAttached


func attach(obj: Node3D, silent: bool = false):
    hasObjectAttached = true
    if obj.is_inside_tree():
        obj.reparent.call_deferred(self)
    else:
        add_child(obj)
    obj.position = Vector3.ZERO
    obj.global_position = self.global_position
    obj.global_rotation = self.global_rotation
    object = obj
    if not silent:
        attached_point.emit(object,seqNumber)   

func transfer(newAttachable: Attachable):
    newAttachable.attach(object)
    deattach()


func getAttached() -> Node3D:
    return object


func deattach():
    deattached_point.emit(object,seqNumber)
    object = null
    hasObjectAttached = false


func deattachAndRemove():
    deattached_point.emit(object,seqNumber)
    hasObjectAttached = false
    object.queue_free()
    object = null