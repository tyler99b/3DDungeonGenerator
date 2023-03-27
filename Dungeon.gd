extends GridMap

var dungeon_map = []
@export var min_width = 3
@export var width:int = 50
@export var height:int = 20
@export var depth:int = 50


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

func bsp(grid_width,grid_height,grid_depth,min_width,min_height,min_depth,iterations):
	set_size(grid_width,grid_height,grid_depth)
	var nodes = []
	for i in pow(2,iterations+1)-1:
		nodes.append(0)
		
	nodes[0] = ([Vector3i.ZERO,Vector3i(grid_width,grid_height,grid_depth)])
	var split_inds = [0]
	for i in iterations:
		print(split_inds)
		if len(split_inds) == 0:
			return nodes
				
		var new_splits = []
		
		for ind in split_inds:
			
			print("ind: " + str(ind))
			#print("before" + str(nodes[ind]))
			var parent
			
			if ind %2 == 0:
				parent = (ind-2)/2
				
			else:
				parent = (ind-1)/2
				
			var split_range = randi_range(0,2)
			
			if split_range == 0:
				print("split x")
				var parent_node = nodes[ind]
				var new_x = (parent_node[1].x - parent_node[0].x)/2 + parent_node[0].x
				if new_x - parent_node[0].x -1 < min_width:
					continue
				var new_vec = Vector3i(new_x, parent_node[1].y, parent_node[1].z)
				nodes[2*ind+1] = [nodes[ind][0], new_vec]
				nodes[2*ind+2] = [Vector3i(new_x+1, parent_node[0].y, parent_node[0].z), nodes[ind][1]]
				
			elif split_range == 1:
				print("split y")
				var parent_node = nodes[ind]
				var new_y = (parent_node[1].y - parent_node[0].y)/2 + parent_node[0].y
				if new_y - parent_node[0].y -1 < min_height:
					continue
				var new_vec = Vector3i(parent_node[1].x, new_y, parent_node[1].z)
				nodes[2*ind+1] = [nodes[ind][0], new_vec]
				nodes[2*ind+2] = [Vector3i(parent_node[0].x, new_y+1, parent_node[0].z), nodes[ind][1]]
				
			else:
				print("split z")
				var parent_node = nodes[ind]
				var new_z = (parent_node[1].z - parent_node[0].z)/2 + parent_node[0].z
				if new_z - parent_node[0].z -1 < min_depth:
					continue
				var new_vec = Vector3i(parent_node[1].x, parent_node[1].y, new_z,)
				nodes[2*ind+1] = [nodes[ind][0], new_vec]
				nodes[2*ind+2] = [Vector3i(parent_node[0].x, parent_node[0].y, new_z+1), nodes[ind][1]]
			
			for j in range(1,3):
				new_splits.append(2*(ind)+j)
			#print("after" + str(nodes[ind]))
		split_inds.clear()
		split_inds = new_splits
		new_splits = []
	print(nodes.slice(pow(2,iterations)-1))
	return nodes.slice(pow(2,iterations)-1)

func fill_data_grid(width, height, depth, x_off, y_off, z_off):
	for i in range(x_off, x_off+width):
		for j in range(y_off, y_off + height):
			for k in range(z_off, z_off + depth):
				dungeon_map[i][j][k] = true

func generate_rooms(splits):
	for split in splits:
		print(split)
		var width = randi_range(1,split[1][0] - split[0][0])
		var height = randi_range(1,split[1][1] - split[0][1])
		var depth = randi_range(1,split[1][2] - split[0][2])
		var x_off = randi_range(0,split[1][0] - split[0][0] - width)
		var y_off = randi_range(0,split[1][1] - split[0][1] - height)
		var z_off = randi_range(0,split[1][2] - split[0][2] - depth)
		fill_data_grid(width,height,depth,x_off,y_off,z_off)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(width):
		var double_arr = []
		
		for j in range(height):
			var single_arr = []
			
			for k in range(depth):
				single_arr.append(false)
			double_arr.append(single_arr)
			
		dungeon_map.append(double_arr)
		
	var splits = bsp(width,height,depth,2,1,2,4)
	generate_rooms(splits)
	#print(dungeon_map)
	#print(dungeon_map)
	for i in range(width):
		
		for j in range(height):
			
			for k in range(depth):
				if dungeon_map[i][j][k]:
					set_cell_item(Vector3i(i,j,k),1)
	#set_cell_item(Vector3i(0,0,0),1)
	#set_cell_item(Vector3i(0,2,0),1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
