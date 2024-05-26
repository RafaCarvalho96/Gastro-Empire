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

func _process(_delta):
    if isCooking:
        progress_bar.ratio = 1 - (timer.time_left / totalTimer)
        burning_progress_bar.ratio = 1 - (timer.time_left / totalTimer)
		

func _on_interact(player: Player):
    if player.attachable.hasAvaliableSlot() and attachable.hasAttachedSlot():
        attachable.transfer(player.attachable)
        _on_stop_action()
        return
    elif not player.attachable.hasAvaliableSlot() and attachable.hasAvaliableSlot():
        player.attachable.transfer(attachable)
        _on_start_action(player)
        return
	
    if not player.attachable.hasAvaliableSlot() and not attachable.hasAvaliableSlot():
        if player.attachable.getAttached() is Plate and attachable.getAttached() is IngredientNode:
            if attachable.getAttached().getResource().isPlateable and player.attachable.getAttached().attachable.hasAvaliableSlot():
                attachable.transfer(player.attachable.getAttached().attachable)
                _on_stop_action()
        if player.attachable.getAttached() is IngredientNode and attachable.getAttached() is Plate:
            if player.attachable.getAttached().getResource().isPlateable and attachable.getAttached().attachable.hasAvaliableSlot():
                player.attachable.transfer(attachable.getAttached().attachable)
                _on_stop_action()


func _on_start_action(_player: Player):
    if isCooking or attachable.hasAvaliableSlot() or not attachable.getAttached() is IngredientNode:
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
    attachable.deattach(0,true)
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
