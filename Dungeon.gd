extends GridMap

var dungeon_map = []
@export var min_width = 3

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
	print(nodes)

# Called when the node enters the scene tree for the first time.
func _ready():
	bsp(50,20,50,2,1,2,4)
	#print(dungeon_map)
	set_cell_item(Vector3i(0,0,0),1)
	set_cell_item(Vector3i(0,2,0),1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
