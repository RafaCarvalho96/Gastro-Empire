extends Resource
class_name Ingredient

@export var id: String
@export var name: String
@export var icon: ImageTexture
@export var isPlateable: bool
@export var platePriority: int = 0
@export var loadCookingDetails: Array[CookingDetail]


var cookingDetails: Dictionary = {}

func loadDetails():
	for ckgDetail: CookingDetail in loadCookingDetails:
		cookingDetails[ckgDetail.action] = ckgDetail


func hasAction(action: IngredientManager.CookingAction) -> bool:
	return cookingDetails.has(action)
