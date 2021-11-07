class_name Consumable
extends Node

var mesh = MeshInstance.new()

func _init():
	mesh.mesh = CubeMesh.new()

func use(var player : KinematicBody, var justPressed : bool):
	if justPressed:
		queue_free()
