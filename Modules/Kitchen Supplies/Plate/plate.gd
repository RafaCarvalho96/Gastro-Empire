extends Node3D
class_name Plate

@export var attachable: Attachable
@onready var attachablePointScene = preload("res://Modules/Attachable/attachable_point.tscn")
@onready var baseLocation = attachable.getPoint().global_position
var attachables: Array[AttachablePoint] = []
var foodPlate: FoodPlate
var attachableCount = 1

func _ready():
	attachables.push_back(attachable.getPoint())
	attachable.getPoint().attached_point.connect(_on_ingredient_attach)
	attachable.getPoint().deattached_point.connect(_on_ingredient_deattach)


func _on_ingredient_attach(object: IngredientNode): 
	var shape: CollisionShape3D = object.shape
	var boxShape: BoxShape3D = shape.shape
	var y = boxShape.size.y / 2
	var newAttachable: AttachablePoint = attachablePointScene.instantiate()
	newAttachable.parent = self
	newAttachable.attached.connect(_on_ingredient_attach)
	newAttachable.deattached.connect(_on_ingredient_deattach)
	add_child(newAttachable)
	attachables.push_back(newAttachable)
	newAttachable.global_position = attachable.getPoint().global_position
	newAttachable.global_position.y += y
	attachableCount += 1
	organizePlate()

func _on_ingredient_deattach(object: IngredientNode):
	for attch in attachables:
		attch.queue_free()
	attachables.clear()
	var newAttachable: AttachablePoint = attachablePointScene.instantiate()
	newAttachable.parent = self
	newAttachable.attached.connect(_on_ingredient_attach)
	newAttachable.deattached.connect(_on_ingredient_deattach)
	add_child(newAttachable)
	attachables.push_back(newAttachable)
	attachableCount = 1
	attachable.getPoint().global_position = baseLocation


func compareIngredientPriority(ingA: IngredientNode, ingB: IngredientNode):
	return ingA.ingredientResource.platePriority > ingB.ingredientResource.platePriority
	


func organizePlate():
	var ingredients: Array[IngredientNode] = []
	for attch: AttachablePoint in attachables:
		if not attch.canAttach():
			ingredients.push_back(attch.getAttached())
	
	ingredients.sort_custom(compareIngredientPriority)
	for ing in ingredients:
		for attch in attachables:
			attch.attach(ing,true)


func checkFoodRecipes():
	var recipe = RecipeManager.checkRecipes(self)
	if recipe.length() > 0:
		foodPlate = RecipeManager.getFoodNode(recipe).foodPlateResource
