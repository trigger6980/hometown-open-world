extends Node
class_name TileStreamer
## Streams map tiles around the player. Loads within LOAD_RADIUS_M,
## unloads beyond UNLOAD_RADIUS_M. Prefetches in the direction of travel.

const LOAD_RADIUS_M := 2000.0
const UNLOAD_RADIUS_M := 3000.0
const PREFETCH_RADIUS_M := 3500.0

@export var player: Node3D
@export var tile_loader: TileLoader

var _loaded: Dictionary = {}   # tile_id -> Tile
var _loading: Dictionary = {}  # tile_id -> true

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	var pos := player.global_position
	_unload_far(pos)
	_load_near(pos)
	_prefetch(pos, player.global_basis.z)

func _unload_far(pos: Vector3) -> void:
	for tile_id in _loaded.keys():
		var tile: Tile = _loaded[tile_id]
		if pos.distance_to(tile.center) > UNLOAD_RADIUS_M:
			tile.queue_free()
			_loaded.erase(tile_id)

func _load_near(pos: Vector3) -> void:
	for tile_id in _tiles_in_radius(pos, LOAD_RADIUS_M):
		if not _loaded.has(tile_id) and not _loading.has(tile_id):
			_loading[tile_id] = true
			tile_loader.request(tile_id, func(tile: Tile) -> void:
				_loaded[tile_id] = tile
				_loading.erase(tile_id)
				add_child(tile)
			)

func _prefetch(pos: Vector3, forward: Vector3) -> void:
	var ahead := pos + forward * 1500.0
	for tile_id in _tiles_in_radius(ahead, 500.0):
		if not _loaded.has(tile_id) and not _loading.has(tile_id):
			_loading[tile_id] = true
			tile_loader.request(tile_id, func(tile: Tile) -> void:
				_loading.erase(tile_id)
				if not _loaded.has(tile_id):
					tile.queue_free()

func _tiles_in_radius(pos: Vector3, radius: float) -> Array:
	# Convert world pos -> tile ids. Implementation depends on TileLoader's CRS.
	return tile_loader.tile_ids_in_radius(pos, radius)
