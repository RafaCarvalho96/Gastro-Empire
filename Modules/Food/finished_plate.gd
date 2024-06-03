extends Node3D
class_name FinishedPlate

@export var id: String
@export var plateName: String
@export var isOrederable: bool = false
@export var price: int = 0
var recipe: Recipe
var ingredients: Array

func registerRecipe():
	recipe = Recipe.new()
	recipe.id = id
	ingredients = get_children()
	for ingredient: IngredientNode in ingredients:
		var ingResource: Ingredient = ingredient.getResource()
		if ingResource.parentIngredient.length() > 0:
			recipe.addIngredient(ingResource.parentIngredient, ingResource.id, recipe.getLastSeqNumber(ingResource.id), ingredient.position, ingredient.rotation, ingredient.scale)
		else:
			recipe.addIngredient(ingResource.id, "", recipe.getLastSeqNumber(ingResource.id), ingredient.position, ingredient.rotation, ingredient.scale)
