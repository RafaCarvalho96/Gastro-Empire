class_name InteractableRaycast
extends RayCast3D

@export var parent: Player

var performingSecondaryAction: bool = false
var activeInteractable: InteractableObject = null
var firePressed: bool = false

func _physics_process(_delta: float):
	if not is_colliding():
		if performingSecondaryAction:
			stopSecondaryAction()
		if firePressed:
			firePressed = false
		return

	var objectInteractable = get_collider()
	if not objectInteractable is InteractableObject:
		if performingSecondaryAction:
			stopSecondaryAction()
		if firePressed:
			firePressed = false
		return

	if Input.is_action_pressed("fire"):
		if not firePressed:
			firePressed = true
	elif firePressed:
		firePressed = false
		objectInteractable.performPrimaryAction(parent)


	if Input.is_action_pressed("action") and not performingSecondaryAction:
		startSecondaryAction(objectInteractable)
	elif not Input.is_action_pressed("action") and performingSecondaryAction:
		stopSecondaryAction() 


func startSecondaryAction(objectInteractable: InteractableObject):
	performingSecondaryAction = true
	activeInteractable = objectInteractable
	activeInteractable.startSecondaryAction(parent)


func stopSecondaryAction():
	performingSecondaryAction = false
	activeInteractable.stopSecondaryAction(parent)
	activeInteractable = null
