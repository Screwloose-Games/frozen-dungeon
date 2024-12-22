class_name Actor
extends CharacterBody2D

signal died

@export var speed: int = 170

var state_machine: StateMachine
@export var initial_state: State

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
