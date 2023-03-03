extends GridMap

var dungeon_map = []

func set_size(width,height,depth):
	for i in width:
		var twod_array = []
		for j in height:
			
			var depth_array = []
			for k in depth:
				depth_array.append(0)
			twod_array.append(depth_array)
		dungeon_map.append(twod_array)
	pass

func bsp(width,height,depth):
	set_size(width,height,depth)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	bsp(5,1,5)
	print(dungeon_map)
	set_cell_item(Vector3i(0,0,0),1)
	set_cell_item(Vector3i(0,2,0),1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
