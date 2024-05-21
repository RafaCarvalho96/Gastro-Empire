class_name Attachable extends Node3D

@export var parent: Node3D
@onready var attach_point = $"Attach Point"

signal attached(object: Node3D)
signal deattached(object: Node3D)

var hasObjectAttached: bool = false
var object: Node3D

func _ready():
	if not parent.has_meta("attachable"):
		parent.set_meta("attachable",self)


func canAttach() -> bool:
	return not hasObjectAttached


func attach(obj: Node3D, silent: bool = false):
	hasObjectAttached = true
	if obj.is_inside_tree():
		obj.reparent.call_deferred(self)
	else:
		add_child(obj)
	obj.position = Vector3.ZERO
	obj.global_position = attach_point.global_position
	obj.global_rotation = attach_point.global_rotation
	object = obj
	if not silent:
		attached.emit(object)


func transfer(newAttachable: Attachable):
	newAttachable.attach(object)
	deattach()


func getAttached() -> Node3D:
	return object


func deattach():
	deattached.emit(object)
	object = null
	hasObjectAttached = false


func deattachAndRemove():
	deattached.emit(object)
	hasObjectAttached = false
	object.queue_free()
	object = null
