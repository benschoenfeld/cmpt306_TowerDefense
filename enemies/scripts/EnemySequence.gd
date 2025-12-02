extends Resource
class_name EnemySequence

## A reference to the type of enenmy (from the resource).
@export var enemy_type: EnemyType

## A reference to the amount of enemites there are to be spawned.
@export var amount: int

## A reference to the duration inbetween addition of enemies to Path2D.
@export var interval: float = 0.5
