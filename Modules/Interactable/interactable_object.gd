class_name InteractableObject
extends Node3D

@export var parent


signal _on_perform_primary_action(player: Player)
signal _on_start_secondary_action(player: Player)
signal _on_stop_secondary_action(player: Player)


func performPrimaryAction(player: Player):
    _on_perform_primary_action.emit(player)


func startSecondaryAction(player: Player):
    _on_start_secondary_action.emit(player)


func stopSecondaryAction(player: Player):
    _on_stop_secondary_action.emit(player)