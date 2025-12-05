class_name EnemyType

extends Resource
## Holds information to make different [Enemy] types.
##
## Holds game balance data and visual/animation data.
##
## To make new types of [Enemy], just make new resource files with 
## different values.

## A reference to the name of the enemy.
@export var name: String

## A reference to the amount of health each enemy has.
@export var health: int

## A reference to the amount of damage each enemy inflicts.
@export var damage: int

## A reference to the speed at which each enemy follows the path.
@export var speed: float

## A reference to the SpriteFrames that represent the AnimatedSprite2D
@export var frames: SpriteFrames

## A reference to the name of the animation that represents walking.
@export var walk_animation: StringName = "walk"
