extends Node3D
class_name Plate

@export var attachable: Attachable: 
	get:
		if attachables.size() > 0:
			return attachables[attachableCount-1]
		return attachable
@onready var attachableScene = preload("res://Modules/Attachable/attachable.tscn")
@onready var baseLocation = attachable.global_position
var attachables: Array[Attachable] = []
var foodPlate: FoodPlate
var attachableCount = 1

func _ready():
	attachables.push_back(attachable)
	attachable.attached.connect(_on_ingredient_attach)
	attachable.deattached.connect(_on_ingredient_deattach)


func _on_ingredient_attach(object: IngredientNode): 
	var shape: CollisionShape3D = object.shape
	var boxShape: BoxShape3D = shape.shape
	var y = boxShape.size.y / 2
	var newAttachable: Attachable = attachableScene.instantiate()
	newAttachable.parent = self
	newAttachable.attached.connect(_on_ingredient_attach)
	newAttachable.deattached.connect(_on_ingredient_deattach)
	add_child(newAttachable)
	attachables.push_back(newAttachable)
	newAttachable.global_position = attachable.global_position
	newAttachable.global_position.y += y
	attachableCount += 1
	organizePlate()

func _on_ingredient_deattach(object: IngredientNode):
	for attch in attachables:
		attch.queue_free()
	attachables.clear()
	var newAttachable: Attachable = attachableScene.instantiate()
	newAttachable.parent = self
	newAttachable.attached.connect(_on_ingredient_attach)
	newAttachable.deattached.connect(_on_ingredient_deattach)
	add_child(newAttachable)
	attachables.push_back(newAttachable)
	attachableCount = 1
	attachable.global_position = baseLocation


func compareIngredientPriority(ingA: IngredientNode, ingB: IngredientNode):
	return ingA.ingredientResource.platePriority > ingB.ingredientResource.platePriority
	


func organizePlate():
	var ingredients: Array[IngredientNode] = []
	for attch: Attachable in attachables:
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
