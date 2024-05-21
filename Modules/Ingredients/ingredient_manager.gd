extends Node

enum CookingAction {CUT, FREEZE, COOK}

var ingredients: Dictionary = {}
var ingredientsScenes: Dictionary = {}


func _ready():
	loadIngredients()


func getIngredientNode(ingredientId: String) -> Node3D:
	return ingredientsScenes[ingredientId].instantiate()


func loadIngredients():
	var files = DirAccess.get_files_at("res://Modules/Ingredients/Resources")
	for file in files:
		var resource: Ingredient = ResourceLoader.load("res://Modules/Ingredients/Resources/%s" % file)
		var scene = ResourceLoader.load("res://Modules/Ingredients/Scenes/%s.tscn" % resource.id)
		ingredients[resource.id] = resource
		ingredientsScenes[resource.id] = scene
		resource.loadDetails()


