extends Node3D
class_name Plate

@export var attachable: Attachable

var validRecipes: Dictionary = {}
var validIngredients: Array[String] = []
var currentIngredients: Array[String] = []
var slots = 0
var isFinishedPlate: bool = false
var finishedPlate: FinishedPlate


func plateIngredient(ingId: String):
	if currentIngredients.size() > 0 and not validIngredients.has(ingId):
		return false
		
	currentIngredients.append(ingId)
	validIngredients.erase(ingId)
	
	if not loadValidRecipes():
		currentIngredients.erase(ingId)
		return false
		
	reloadPlatePositions()
	return true

func plate(oldAttachable: Attachable) -> bool:
	var ingredient: Ingredient = oldAttachable.getAttached().getResource()
	if not ingredient.isPlateable:
		return false
		
	if currentIngredients.size() > 0 and not validIngredients.has(ingredient.id):
		return false
	
	currentIngredients.append(ingredient.id)
	validIngredients.erase(ingredient.id)
	
	if not loadValidRecipes():
		currentIngredients.erase(ingredient.id)
		return false
	oldAttachable.deattach(0,true)
	reloadPlatePositions()
	
	return true


func unplate():
	var ing = currentIngredients.pop_back()
	validIngredients.push_back(ing)
	attachable.clear()
	loadValidRecipes()
	reloadPlatePositions()
	


func reloadPlatePositions() -> bool:
	var recipe: Recipe = getNextRecipe()
	if recipe == null:
		return false
	
	if missingIngredientsAmount(recipe) == 0:
		isFinishedPlate = true
		finishedPlate = RecipeManager.getFinishedPlate(recipe.id)
	else:
		isFinishedPlate = false
		finishedPlate = null


	attachable.clear()

	for recipeTransform: RecipeTransform in recipe.transforms:
		if currentIngredients.has(recipeTransform.ingredientId):
			var variant = recipeTransform.ingredientId
			if recipeTransform.variantId.length() > 0:
				variant = recipeTransform.variantId
			if attachable.isAvaliableSlot(slots):
				var slot = attachable.attachableMode.slots[slots]
				attachable.attach(IngredientManager.getIngredientNode(variant),slot.seqNumber)
			else:
				slots += 1
				var slot = attachable.createSlot(slots)
				attachable.attach(IngredientManager.getIngredientNode(variant),slot.seqNumber)
				slot.position = recipeTransform.position
				slot.rotation = recipeTransform.rotation
				if recipeTransform.scale != Vector3.ZERO:
					slot.scale = recipeTransform.scale
	return true

func loadValidRecipes():
	if currentIngredients.size() == 0:
		return false
	if currentIngredients.size() == 1:
		for recipe: Recipe in RecipeManager.recipes.values():
			if recipe.ingredientList.has(currentIngredients[0]):
				validRecipes[recipe.id] = recipe
	else:
		var lastIng = currentIngredients.back()
		for recipe: Recipe in validRecipes.values():
			if not recipe.ingredientList.has(lastIng):
				validRecipes.erase(recipe.id)
	loadValidIngredients()
	if validRecipes.size() == 0:
		return false
	return true


func loadValidIngredients():
	validIngredients.clear()
	for recipe: Recipe in validRecipes.values():
		for ing: String in recipe.ingredientList:
			if not validIngredients.has(ing) and not currentIngredients.has(ing):
				validIngredients.append(ing)


func getNextRecipe() -> Recipe:
	var nextRecipe: Recipe = null
	var missingIngredients = 0

	for recipe: Recipe in validRecipes.values():
		var amt = missingIngredientsAmount(recipe)
		if amt <= missingIngredients or nextRecipe == null:
			nextRecipe = recipe
			missingIngredients = amt
	
	return nextRecipe


func missingIngredientsAmount(recipe: Recipe) -> int:
	var missingIngredients = 0
	
	for ing: String in recipe.ingredientList:
		if not currentIngredients.has(ing):
			missingIngredients += 1
	
	return missingIngredients


func isIngredientAllowed(ingredientId: String) -> bool:
	return validIngredients.has(ingredientId) or validRecipes.size() == 0
