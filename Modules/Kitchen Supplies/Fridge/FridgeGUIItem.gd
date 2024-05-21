extends PanelContainer
class_name FridgeGUIItem

@export var button: Button
@export var quantity: Label

var ingredientId: String

func setIngredientId(id: String):
	ingredientId = id


func setTitle(text: String):
	button.text = str(text)


func setQuantity(qtd: int):
	quantity.text = str(qtd)
