extends Resource
class_name Recipe

var id: String
var ingredientList: Array[String]
var transforms: Array = []


func addIngredient(ingredientId: String, variantId: String, seqNumber: int, position: Vector3, rotation: Vector3, scale: Vector3):
	id = ingredientId
	if not ingredientList.has(ingredientId):
		ingredientList.append(ingredientId)
	var recipeTransform = RecipeTransform.new()
	recipeTransform.ingredientId = ingredientId
	recipeTransform.variantId = variantId
	recipeTransform.seqNumber = seqNumber
	recipeTransform.position = position
	recipeTransform.rotation = rotation
	recipeTransform.scale = scale
	transforms.append(recipeTransform)


func hasIngredient(ingredientId: String) -> bool:
	return ingredientList.has(ingredientId)


func getLastSeqNumber(ingredientId: String):
	var seqNumber = 0

	for ingTransform: RecipeTransform in transforms:
		if ingTransform.ingredientId == ingredientId:
			seqNumber += 1 
	
	return seqNumber