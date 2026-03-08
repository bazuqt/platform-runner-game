extends Node2D

@export_category("Building")
@export var front_sprites : Array[Resource]
var sprite
var point 
var onScreen
var last_chosen =-1

func get_spawn_point(num: int) -> Vector2:
	last_chosen = num  
	SpawnBuilding() 
	return $SpawnPoint.position  

func get_last_chosen():
	return last_chosen

func SpawnBuilding():
	point = $SpawnPoint
	sprite = $Sprite2D
	onScreen = $OnScreen
	frontbuildingspawn()


func frontbuildingspawn():
	var sprite_width
	var sprite_height
	var array_size = front_sprites.size() -1
	var new_sprite = randi_range(0, array_size)
	while last_chosen == new_sprite:
		new_sprite = randi_range(0, array_size)
	last_chosen = new_sprite
	sprite.texture = front_sprites[new_sprite]
	sprite_width = sprite.texture.get_size().x
	sprite_height = sprite.texture.get_size().y
	sprite.position = Vector2(sprite_width/2,(-sprite_height/2)-27)
	point.position = Vector2(sprite_width,0)
	onScreen.position = Vector2(sprite_width/2,0)
	
	
	
	
	
