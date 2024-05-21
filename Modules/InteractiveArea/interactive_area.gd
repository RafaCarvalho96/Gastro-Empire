class_name InteractiveArea extends Area3D

@export var parent: Node3D
@export var interactivePriority: int = 0
@export var interactionCallback: String = "_on_interact"
@export var actionStartCallback: String = ""
@export var actionStopCallback: String = ""

var fireCallback: Callable
var actStartCallback: Callable
var actStopCallback: Callable

var active: bool = false
var player: Player
var actionStarted: bool = false

func _ready():
	if interactionCallback.length() > 0:
		fireCallback = Callable(parent, interactionCallback)
	
	if actionStartCallback.length() > 0:
		actStartCallback = Callable(parent, actionStartCallback)
	
	if actionStopCallback.length() > 0:
		actStopCallback = Callable(parent, actionStopCallback)
	
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)
	if not parent.has_meta("interactable"):
		parent.set_meta("interactable",self)


func _unhandled_input(event):
	if not active:
		return
		
	if interactionCallback.length() > 0 and event.is_action_released("fire"):
		fireCallback.bind(player).call_deferred()
	if actionStartCallback.length() > 0 and event.is_action_pressed("action"):
		actStartCallback.bind(player).call_deferred()
		actionStarted = true
	if actionStopCallback.length() > 0 and event.is_action_released("action"):
		actStopCallback.bind(player).call_deferred()
		actionStarted = false


func _on_area_entered(area: Area3D):
	if area is FrontCollider:
		player = area.parent
		if player.activeArea != null and player.activeArea.interactivePriority >= interactivePriority:
			player = null
			return 
		player.activeArea = self
		active = true


func _on_area_exited(area):
	active = false
	if player != null and player.activeArea != null and player.activeArea == self:
		player.activeArea = null
	player = null
	if actionStarted and actionStopCallback.length() > 0:
		actionStarted = false
		actStopCallback.bind(player).call_deferred()
