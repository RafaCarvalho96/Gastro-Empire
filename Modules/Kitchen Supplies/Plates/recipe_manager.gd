extends Node

var foods: Dictionary = {}
var foodScenes: Dictionary = {}


func _ready():
	loadIngredients()


func checkRecipes(plate: Plate) -> String:
	for food: FoodPlate in foods:
		var remaining: Array[String] = []
		for ing: Ingredient in food.ingredients:
			remaining.push_back(ing.id)
		for attachable: Attachable in plate.attachables:
			var ing = attachable.getAttached()
			if ing != null:
				if remaining.has(ing.ingredientResource.id):
					remaining.erase(ing.ingredientResource.id)
				else:
					break
		if remaining.size() < 1:
			return food.id
	return ""


func getFoodNode(foodId: String) -> Node3D:
	return foodScenes[foodId].instantiate()


func loadIngredients():
	var files = DirAccess.get_files_at("res://Modules/Plates/Resources")
	for file in files:
		var resource: FoodPlate = ResourceLoader.load("res://Modules/Plates/Resources/%s" % file)
		var scene = ResourceLoader.load("res://Modules/Ingredients/Plates/%s.tscn" % resource.id)
		foods[resource.id] = resource
		foodScenes[resource.id] = scene
