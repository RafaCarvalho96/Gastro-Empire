extends Node3D
class_name Stove

@export var attachable: Attachable
@onready var progress_bar = $"Cooking Progess/SubViewport/ProgressBar"
@onready var counter_2 = $"../Counter2"
@onready var cooking_progess = $"Cooking Progess"
@onready var burning_progess = $"Burning Progess"
@onready var burning_progress_bar = $"Burning Progess/SubViewport/BurningProgressBar"


var isCooking: bool = false
var cookingRatio: int = 0
var totalTimer: float
var timer: SceneTreeTimer
var ingredient: Ingredient
var actionDetail: CookingDetail
var isBurning: bool = false

func _ready():
	counter_2.attachable.attach(self)

func _process(delta):
	if isCooking:
		progress_bar.ratio = 1 - (timer.time_left / totalTimer)
		burning_progress_bar.ratio = 1 - (timer.time_left / totalTimer)
		

func _on_interact(player: Player):
	if player.attachable.canAttach() and not attachable.canAttach():
		attachable.transfer(player.attachable)
		_on_stop_action()
		return
	elif not player.attachable.canAttach() and attachable.canAttach():
		player.attachable.transfer(attachable)
		_on_start_action(player)
		return
	
	if not player.attachable.canAttach() and not attachable.canAttach():
		if player.attachable.getAttached() is Plate and attachable.getAttached() is IngredientNode:
			if attachable.getAttached().getResource().isPlateable and player.attachable.getAttached().attachable.canAttach():
				attachable.transfer(player.attachable.getAttached().attachable)
		if player.attachable.getAttached() is IngredientNode and attachable.getAttached() is Plate:
			if player.attachable.getAttached().getResource().isPlateable and attachable.getAttached().attachable.canAttach():
				player.attachable.transfer(attachable.getAttached().attachable)


func _on_start_action(player: Player):
	if isCooking or attachable.canAttach() or not attachable.getAttached() is IngredientNode:
		return
	
	ingredient = attachable.getAttached().getResource()
	if not ingredient.hasAction(IngredientManager.CookingAction.COOK):
		return
	actionDetail = ingredient.getActionDetail(IngredientManager.CookingAction.COOK)
	
	_start_cooking(actionDetail.timer)


func _on_stop_action():
	if not isCooking:
		return
		
	_stop_cooking()


func _on_timer_timeout():
	if not isCooking:
		return
	_stop_cooking()
	attachable.deattachAndRemove()
	attachable.attach(IngredientManager.getIngredientNode(actionDetail.result.id))
	if attachable.getAttached().getResource().hasAction(IngredientManager.CookingAction.COOK):
		ingredient = attachable.getAttached().getResource()
		actionDetail = ingredient.getActionDetail(IngredientManager.CookingAction.COOK)
		_start_cooking(actionDetail.timer)


func _start_cooking(seconds: float):
	isCooking = true
	isBurning = actionDetail.burn
	timer = get_tree().create_timer(seconds)
	timer.timeout.connect(_on_timer_timeout)
	totalTimer = seconds
	progress_bar.ratio = 0
	burning_progress_bar.ratio = 0
	
	if isBurning:
		burning_progess.visible = true
	else:
		cooking_progess.visible = true


func _stop_cooking():
	isCooking = false
	isBurning = false
	timer.time_left = 0.0
	totalTimer = 0
	cooking_progess.visible = false
	burning_progess.visible = false
