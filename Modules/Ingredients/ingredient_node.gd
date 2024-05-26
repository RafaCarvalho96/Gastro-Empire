extends Node3D
class_name IngredientNode

@export var ingredientResource: Ingredient
@export var collisionShape: CollisionShape3D

func getResource() -> Ingredient:
    return ingredientResource


func getCollisionShape() -> CollisionShape3D:
    return collisionShape


func getShape() -> Shape3D:
    return getCollisionShape().shape


func getWidth() -> float:
    var shape = getShape()
    if shape is BoxShape3D:
        return shape.size.x
    elif shape is CapsuleShape3D:
        return shape.radius * 2
    return 0


func getHeight() -> float:
    var shape = getShape()
    if shape is BoxShape3D:
        return shape.size.y
    elif shape is CapsuleShape3D:
        return shape.height
    return 0


func getDepth() -> float:
    var shape = getShape()
    if shape is BoxShape3D:
        return shape.size.z
    elif shape is CapsuleShape3D:
        return shape.radius * 2
    return 0