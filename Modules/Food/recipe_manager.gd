extends Node

var finishedPlates: Dictionary = {}
var recipes: Dictionary = {}

func _ready():
	loadRecipes()


func getRecipe(recipeId: String) -> Recipe:
	return recipes[recipeId]


func loadRecipes():
	var files = DirAccess.get_files_at("res://Modules/Food/Finished Plates")
	for file in files:
		var resource: FinishedPlate = ResourceLoader.load("res://Modules/Food/Finished Plates/%s" % file).instantiate()
		resource.registerRecipe()
		finishedPlates[resource.id] = resource
		recipes[resource.id] = resource.recipe


func getFinishedPlate(plateId: String) -> FinishedPlate:
	return finishedPlates.get(plateId)