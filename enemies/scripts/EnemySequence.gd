class_name EnemySequence

extends Resource
## Holds information for what type of [Enemy] will be spawned in and how many.
##
## To make different [EnemySequence]'s just make a new resource file with 
## different values.

## A reference to the type of enenmy (from the resource).
@export var enemy_type: EnemyType

## A reference to the amount of enemites there are to be spawned.
@export var amount: int

## A reference to the duration inbetween addition of enemies to Path2D.
@export var interval: float = 0.5
