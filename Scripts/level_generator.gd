extends Node2D

@export_category("Terrain")
@export var biome_size : int = 20
@export var speed_increase_treshold : int = 50
@export var change_biome_prob : int = 6
var generated_tiles_count : int
var biome_tiles_count : int

@export_category("Parallax")
@export var Parallax : Array[Parallax2D]

@export var updown_prob : int
@export var straight_terrain : Array[PackedScene]
@export var upwards : Array[PackedScene]
@export var downwards : Array[PackedScene]
@export var SpecialTiles : Array[PackedScene]
@export var NoSpawnTileForSpecialTiles : Array[Resource]
@export var SpecialTilesAmount : int 
@export var onScreen_height := 10000
var last_terrain := 0
@export var old_tile_spawn_location := Vector2(0, 0)
@export var tile_spawn_location := Vector2(640, 334)
@export var new_tile_spawn_location := Vector2(0, 0)
@export var Tree_tile_spawn_location := Vector2(640, 334)
@export var ElectricPole_tile_spawn_location := Vector2(960, 334)
@export var FrontDecor_tile_spawn_location := Vector2(640, 334)
@export var Atmosphere_tile_spawn_location := Vector2(960, 334)
@export var BackFrontDecor_tile_spawn_location := Vector2(960, 334)
@export var FrontBuildNew_tile_spawn_location := Vector2(0, 334)
@export var MidBuildNewtile_spawn_locationnew := Vector2(0, 334)
@export var tile_spawn_node : Node

@export_category("Background")
@export var front_spritesnew : Array[Resource]
@export var front_sprites : Array[Resource]
@export var back_sprites : Array[Resource]
@export var Atmosphere_sprites : Array[Resource]
@export var Tree_sprites : Array[Resource]
@export var FrontDecor_sprites : Array[Resource]
@export var ElectricPole_sprites : Array[Resource]
@export var back_buildings_scale := 0.7


var front_marker : Marker2D
var mid_marker : Marker2D
var midback_marker : Marker2D
var frontbuildingobject_marker : Marker2D
var back_marker : Marker2D
var frontbuildingobject_limit := 640
var front_limit := 640
var mid_limit := 640
var midback_limit := 640
var back_limit := 640
var last_chosen := -1
var last_chosen1 := -1
var last_chosen2 := -1
var get_special_tiles := 0
var FrontHouseAdd := 0
var SecialTileArray = -1
var SecialTileArrayCheck3ok = [0, 0, 0]
var EndSpaceVector = 0

func _ready() -> void:
	Global.spawn_remote.connect(spawn_tile)
	front_marker = $FrontMarker
	mid_marker = $MidMarker
	back_marker = $BackMarker
	midback_marker = $MidBackMarker

	Global.stop_spawn.emit()
	
	back_spawn_background()
	MidBack_spawn_background()
	FrontDecorSpawn()
	FrontBuildNew()
	BackFrontDecorSpawn()
	MidBuildNew()
	ElectricPole()
	TreeSpawn()
	Global.spawn_remote.connect(TreeSpawn)
	Global.spawn_remote.connect(ElectricPole)
	Global.spawn_remote.connect(FrontDecorSpawn)	
	Global.spawn_remote.connect(BackFrontDecorSpawn)	
	Global.spawn_remote.connect(Atmosphere)	
	Global.spawn_remote.connect(FrontBuildNew)	
	Global.spawn_remote.connect(MidBuildNew)	
	Global.disable_vertical_parallax.connect(parallax_change)

func spawn_tile():
	var new_tile 
	get_special_tiles += 1;	
	if get_special_tiles < SpecialTilesAmount:
		new_tile = straight_terrain.pick_random().instantiate()
		last_terrain = 0
	else:
		var array_size = SpecialTiles.size() -1
		SecialTileArray = randi_range(0, array_size)
		new_tile = SpecialTiles[SecialTileArray].instantiate()
		old_tile_spawn_location = tile_spawn_location
		EndSpaceVector = new_tile.get_spawn_point()
		new_tile_spawn_location = EndSpaceVector + tile_spawn_location
		get_special_tiles = 0
		if SecialTileArray >= 2:
			Global.stop_spawn.emit()
		if SecialTileArray == 2:
			get_special_tiles = -10
	new_tile.position = tile_spawn_location
	new_tile.get_node("OnScreen").screen_entered.connect(spawn_tile)
	tile_spawn_location += new_tile.get_spawn_point()
	

	tile_spawn_node.add_child(new_tile)
	#count_tiles()

func count_tiles():
	generated_tiles_count += 1
	if generated_tiles_count % speed_increase_treshold == 0:
		Global.speed_bumped.emit()

func back_spawn_background():
	var onScreen
	var respawnOnScreen
	var sprite_width
	var sprite_height

	while back_marker.position.x < back_limit:
		var sprite = Sprite2D.new()
		sprite.texture = back_sprites.pick_random()
		sprite.scale = Vector2(back_buildings_scale, back_buildings_scale)
		sprite_width = sprite.texture.get_size().x
		sprite_height = sprite.texture.get_size().y
		onScreen = VisibleOnScreenNotifier2D.new()
		onScreen.position = back_marker.position + Vector2(sprite_width,0)	
		onScreen.rect = Rect2(-50,-250,100,500)
		onScreen.add_child(sprite)
		sprite.offset = Vector2(-sprite_width/2, -sprite_height/2) 
		onScreen.screen_exited.connect(onScreen.queue_free)
		back_marker.position.x += sprite_width
		$BackBuildings.add_child(onScreen)
	respawnOnScreen = VisibleOnScreenNotifier2D.new()
	respawnOnScreen.position -= Vector2(sprite_width, -650)
	respawnOnScreen.screen_entered.connect(back_spawn_background)
	onScreen.add_child(respawnOnScreen)
	back_limit += int(back_marker.position.x)

var FrontCounterBuilding = 0
var RandomNoFrontBuilding = randi_range(15,25)
var RandomNoMidBuilding = randi_range(30,40)
var MidCounterBuilding = 0

func MidBack_spawn_background():
	var onScreen
	var respawnOnScreen
	var sprite_width
	var sprite_height
	while midback_marker.position.x < midback_limit:
		var sprite = Sprite2D.new()
		var array_size = front_sprites.size() -1
		var new_sprite = randi_range(0, array_size)
		while last_chosen2 == new_sprite:
			new_sprite = randi_range(0, array_size)
		last_chosen2 = new_sprite
		sprite.texture = front_sprites[new_sprite]	
		sprite_width = sprite.texture.get_size().x
		sprite_height = sprite.texture.get_size().y
		onScreen = VisibleOnScreenNotifier2D.new()
		onScreen.position = midback_marker.position + Vector2(sprite_width, -sprite_height/2)
		onScreen.add_child(sprite)
		sprite.offset = Vector2(-sprite_width/2, 0) 
		onScreen.screen_exited.connect(onScreen.queue_free)
		midback_marker.position.x += sprite_width
		$MidBackBuilding.add_child(onScreen)
	respawnOnScreen = VisibleOnScreenNotifier2D.new()
	respawnOnScreen.position -= Vector2(sprite_width, 0)
	respawnOnScreen.screen_entered.connect(MidBack_spawn_background)
	onScreen.add_child(respawnOnScreen)
	midback_limit += int(midback_marker.position.x)

func TreeSpawn():
	var new_tile 
	var num = randi_range(0,Tree_sprites.size()-1)
	new_tile = Tree_sprites[num].instantiate()	
	var randomX1 := Vector2(randi_range(0,1000), 0)
	#frontbuild_sprites.pick_random().instantiate()
	new_tile.position = get_space_position_vector(Tree_tile_spawn_location)   
	new_tile.get_node("OnScreen").screen_entered.connect(TreeSpawn)
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	Tree_tile_spawn_location += randomX1
	Tree_tile_spawn_location += get_space_position_vector2(Tree_tile_spawn_location, new_tile.get_spawn_point() )
	$Tree.add_child(new_tile)
	
func FrontDecorSpawn():
	
	var new_tile 
	var num = randi_range(0,FrontDecor_sprites.size()-1)
	new_tile = FrontDecor_sprites[num].instantiate()
	var randomX1 := Vector2(randi_range(1,1000), 0)
	#frontbuild_sprites.pick_random().instantiate()
	new_tile.position = get_space_position_vector(FrontDecor_tile_spawn_location)   
	new_tile.get_node("OnScreen").screen_entered.connect(FrontDecorSpawn)
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	FrontDecor_tile_spawn_location += randomX1
	FrontDecor_tile_spawn_location += get_space_position_vector2(FrontDecor_tile_spawn_location, new_tile.get_spawn_point())
	$FrontDecorBuildings.add_child(new_tile)

func BackFrontDecorSpawn():	
	var new_tile 
	if SecialTileArray >= 2:
		BackFrontDecor_tile_spawn_location += EndSpaceVector
	var randomsprite = randi_range(0,2)
	if randomsprite == 0:
		var num = randi_range(0,FrontDecor_sprites.size()-1)
		new_tile = FrontDecor_sprites[num].instantiate()
	elif randomsprite == 1:
		var num = randi_range(0,ElectricPole_sprites.size()-1)
		new_tile = ElectricPole_sprites[num].instantiate()
	else:
		var num = randi_range(0,Tree_sprites.size()-1)
		new_tile = Tree_sprites[num].instantiate()	
	var randomX = randi_range(1,150);
	var randomX1 := Vector2(randomX, 0)
	if randomsprite == 0 or randomsprite == 2:
		new_tile.turn_off()
	#frontbuild_sprites.pick_random().instantiate()
	new_tile.position = BackFrontDecor_tile_spawn_location
	new_tile.get_node("OnScreen").screen_entered.connect(BackFrontDecorSpawn)
	
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	
	BackFrontDecor_tile_spawn_location += randomX1
	BackFrontDecor_tile_spawn_location += new_tile.get_spawn_point()
	$MidDecorBuilding.add_child(new_tile)

var NonRepeatNum1 = -1
var EmptySpace1 = 0
var get4buildingfirst = 0

func get_space_position_vector(location : Vector2) -> Vector2:
	var new_tile: Vector2
	if location >= old_tile_spawn_location and location <= new_tile_spawn_location: 
		new_tile= location + EndSpaceVector
	else:
		new_tile = location 
	return new_tile

func get_space_position_vector2(location : Vector2, location2 : Vector2) -> Vector2:
	var new_tile: Vector2
	if location >= old_tile_spawn_location and location <= new_tile_spawn_location: 
		new_tile= location2 + EndSpaceVector
	else:
		new_tile = location2 
	return new_tile

func FrontBuildNew():
	EmptySpace1 +=1	
	var new_tile
	new_tile = front_spritesnew[0].instantiate()
	new_tile.position = get_space_position_vector(FrontBuildNew_tile_spawn_location)   
	new_tile.get_node("OnScreen").screen_entered.connect(FrontBuildNew)
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	FrontBuildNew_tile_spawn_location += get_space_position_vector2(FrontBuildNew_tile_spawn_location, new_tile.get_spawn_point(NonRepeatNum1))
	NonRepeatNum1 = new_tile.get_last_chosen()
	$FrontBuildings.add_child(new_tile)

var NonRepeatNum2 = -1	
func MidBuildNew():	
	var new_tile 
	new_tile = front_spritesnew[0].instantiate()	
	#frontbuild_sprites.pick_random().instantiate()
	new_tile.position = MidBuildNewtile_spawn_locationnew
	new_tile.get_node("OnScreen").screen_entered.connect(MidBuildNew)
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	MidBuildNewtile_spawn_locationnew += new_tile.get_spawn_point(NonRepeatNum2)
	NonRepeatNum2 = new_tile.get_last_chosen()
	$MidBuilding.add_child(new_tile)

func ElectricPole():
	var new_tile 
	var num = randi_range(0,ElectricPole_sprites.size()-1)
	new_tile = ElectricPole_sprites[num].instantiate()
	#ElectricPole_sprites.pick_random().instantiate()
	new_tile.position = get_space_position_vector(ElectricPole_tile_spawn_location)   
	new_tile.get_node("OnScreen").screen_entered.connect(ElectricPole)
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	ElectricPole_tile_spawn_location += get_space_position_vector2(ElectricPole_tile_spawn_location, new_tile.get_spawn_point())
	$LightPole.add_child(new_tile)

func Atmosphere():
	var new_tile = Atmosphere_sprites[0].instantiate()
	new_tile.position = Atmosphere_tile_spawn_location	
	new_tile.get_node("OnScreen").screen_entered.connect(Atmosphere)
	
	var onScreen = new_tile.get_node("OnScreen")
	onScreen.scale.y = onScreen_height
	
	Atmosphere_tile_spawn_location += new_tile.get_spawn_point()
	$Atmosphere.add_child(new_tile)

func parallax_change():
	var par = $BackBuildings.scroll_scale.x
	$BackBuildings.set_scroll_scale(Vector2(par, par))
	par = $MidBackBuilding.scroll_scale.x
	$MidBackBuilding.set_scroll_scale(Vector2(par, par))
	par = $MidBuilding.scroll_scale.x
	$MidBuilding.set_scroll_scale(Vector2(par, par))
	par = $MidDecorBuilding.scroll_scale.x
	$MidDecorBuilding.set_scroll_scale(Vector2(par, par))
