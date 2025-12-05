class_name TowerResource

extends Resource
## A data container describing stats, visuals, and behavior of a tower.
##
## A [TowerResource] holds all the values needed to create and operate a tower.
## This includes name, cost, damage, attack, speed, range,
## projectile information, and textures.

## The name of this tower.
@export var tower_name: String = ""

## The icon used in UI menus.
@export var icon: Texture2D

## The texture for the tower turret rotation.
@export var turret_texture: Texture2D

## The cost of placing this tower.
@export var cost: int = 0

## The amount of damage each bullet fired by this tower inflicts.
@export var damage: int = 1

## The number of shots the tower fires per second.
@export var fire_rate: float = 1.0

## The attack radius of the tower (how far it can detect enemies).
@export var area_range: float = 100

## The [PackedScene] used to spawn bullets when the tower fires.
@export var bullet_scene: PackedScene

## The speed at which spawned bullets travel.
@export var bullet_speed: float = 600.0

## The sound each bullet plays when fired.
@export var bullet_sound: AudioStream

## Returns the cost of placing this tower.
func get_cost() -> int:
	return cost
