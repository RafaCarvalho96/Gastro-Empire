class_name InteractableRaycast
extends RayCast3D

@export var parent: Player

var performingSecondaryAction: bool = true
var activeInteractable: InteractableObject = null

func _physics_process(delta: float):
    if not is_colliding():
        if performingSecondaryAction:
            stopSecondaryAction()
        return
    
    var objectInteractable = get_collider().get_parent()
    if not objectInteractable is InteractableObject:
        if performingSecondaryAction:
            stopSecondaryAction()
        return
    
    if Input.is_action_pressed("fire"):
        objectInteractable.performPrimaryAction(parent):
    
    if Input.is_action_pressed("action") and not performingSecondaryAction:
        startSecondaryAction(objectInteractable: InteractableObject)
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