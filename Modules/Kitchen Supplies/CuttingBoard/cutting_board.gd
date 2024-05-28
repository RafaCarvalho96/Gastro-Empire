extends Utensil
class_name CuttingBoard

@export var attachable: Attachable
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar
@onready var counter_2 = $"../Counter"
@onready var sprite_3d = $Sprite3D

var isCutting: bool = false
var cuttingRatio: int = 0
var totalTimer: float
var timer: SceneTreeTimer
var ingredient: Ingredient
var actionDetail: CookingDetail

func _ready():
	counter_2.attachable.attach(self)

func _process(_delta):
	if isCutting:
		progress_bar.ratio = 1 - (timer.time_left / totalTimer)
		

func _on_interact(player: Player):
	if player.attachable.hasAvaliableSlot() and not attachable.hasAvaliableSlot():
		attachable.transfer(player.attachable)
		return
	elif not player.attachable.hasAvaliableSlot() and attachable.hasAvaliableSlot():
		player.attachable.transfer(attachable)
		return
	
	if not player.attachable.hasAvaliableSlot() and not attachable.hasAvaliableSlot():
		if player.attachable.getAttached() is Plate and attachable.getAttached() is IngredientNode:
			if attachable.getAttached().getResource().isPlateable and player.attachable.getAttached().attachable.hasAvaliableSlot():
				attachable.transfer(player.attachable.getAttached().attachable)
		if player.attachable.getAttached() is IngredientNode and attachable.getAttached() is Plate:
			if player.attachable.getAttached().getResource().isPlateable and attachable.getAttached().attachable.hasAvaliableSlot():
				player.attachable.transfer(attachable.getAttached().attachable)
	
func _on_start_action(_player: Player):
	if isCutting or attachable.hasAvaliableSlot() or not attachable.getAttached() is IngredientNode:
		return
	
	ingredient = attachable.getAttached().getResource()
	if not ingredient.hasAction(IngredientManager.CookingAction.CUT):
		return
	actionDetail = ingredient.getActionDetail(IngredientManager.CookingAction.CUT)
	
	_start_cutting(actionDetail.timer)


func _on_stop_action(_player: Player):
	if not isCutting:
		return
		
	_stop_cutting()


func _on_timer_timeout():
	if not isCutting:
		return
	_stop_cutting()
	attachable.deattach(0,true)
	if actionDetail.result != null:
		attachable.attach(IngredientManager.getIngredientNode(actionDetail.result.id))


func _start_cutting(seconds: float):
	isCutting = true
	timer = get_tree().create_timer(seconds)
	timer.timeout.connect(_on_timer_timeout)
	totalTimer = seconds
	progress_bar.ratio = 0
	sprite_3d.visible = true


func _stop_cutting():
	isCutting = false
	timer.time_left = 0.0
	totalTimer = 0
	sprite_3d.visible = false
