class_name Attachable extends Node3D

enum ObjectCategories {UTENSIL, PLATE, INGREDIENT, FOOD}

@export var parent: Node3D
@export var orderned: bool = true

signal attached(object: Node3D,point: int)
signal deattached(object: Node3D,point: int)

var points: Dictionary = {}
var availablePoints: Array[int] = []
var occupiedPoints: Array[int] = []
var pointCount: int = 0
var pointPointer: int = 0

func _ready():
	if not parent.has_meta("attachable"):
		parent.set_meta("attachable",self)
	
	pointCount = 0
	for node: Node3D in get_children():
		if node is AttachablePoint:
			points[node.seqNumber] = node
			availablePoints.push_back(node.seqNumber)
			pointCount += 1
	availablePoints.sort_custom(sortAsc)
	
	for point: AttachablePoint in points.values():
		point.attached_point.connect(_on_point_attach)
		point.deattached_point.connect(_on_point_deattach)


func sortAsc(a,b):
	return a<b


func canAttach(point: int = -1) -> bool:
	return getPoint(point).canAttach()


func hasObject(point: int = -1) -> bool:
	return getPoint(point).hasObject()


func attach(obj: Node3D,point: int = -1):
	getPoint(point).attach(obj,false)


func transfer(newAttachable: Attachable,point: int = -1):
	getPoint(point).transfer(newAttachable)


func getAttached(point: int = -1) -> Node3D:
	return getPoint(point).getAttached()


func deattach(point: int = -1):
	getPoint(point).deattach()


func deattachAndRemove(point: int = -1):
	getPoint(point).deattachAndRemove()


func getPoint(pointSeq: int = -1) -> AttachablePoint:
	if points.size() < 1:
		return null

	if orderned or pointSeq == -1:
		if availablePoints.size() > 0:
			return points[availablePoints.back()]
		elif occupiedPoints.size() > 0:
			return points[occupiedPoints.back()]

	if not points.has(pointSeq):
		return null

	return points[pointSeq]


func _on_point_attach(node: Node3D,point: int = -1):
	if orderned:
		point = availablePoints.pop_back()
		occupiedPoints.push_back(point)
	else:
		availablePoints.erase(point)
		occupiedPoints.append(point)

	attached.emit(node,point)


func _on_point_deattach(node: Node3D,point: int = -1):
	if orderned:
		point = occupiedPoints.pop_back()
		availablePoints.push_back(point)
	else:
		occupiedPoints.erase(point)
		availablePoints.append(point)

	deattached.emit(node,point)