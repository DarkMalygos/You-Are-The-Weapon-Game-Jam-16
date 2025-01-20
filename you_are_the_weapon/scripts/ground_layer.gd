extends TileMapLayer

var a_star_grid = AStarGrid2D.new()
var layer_rect = Rect2i()

func _ready():
	# Az egész pályának a méretét adja vissza
	layer_rect = get_used_rect()
	# A TileSet-hez tartozó tile-ok mérete
	var tile_size = tile_set.tile_size
	
	a_star_grid.region = layer_rect
	a_star_grid.cell_size = tile_size
	# Manhattan távolság számítása, mivel nem mozognak az entity-k átlósan
	# Pontos értékét számít, ez lassú.
	a_star_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	a_star_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	# Updateljük az a_star_gridet
	a_star_grid.update()
	
	# Végigmegyünk az összes cellán és, ha a cella 'wall' típusú akkor solid típusú lesz a cella
	for x in layer_rect.size.x:
		for y in layer_rect.size.y:
			var coords = Vector2i(x + layer_rect.position.x, y + layer_rect.position.y)
			var tile_data = get_cell_tile_data(coords)
			if tile_data and tile_data.get_custom_data('type') == 'wall':
				a_star_grid.set_point_solid(coords)
