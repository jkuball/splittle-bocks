extends Node2D

var decaying: bool = false

func begin_decay():
	if not decaying:
		print_debug(self, ": I am dying :(")
		decaying = true
