/// @function scr_display_action_nodes(start_node, range)
/// @description Generate a list that contains all the nodes that can be used for... movement / attacking etc
/// @param start_node {real} the instance_id of the node that we want to calculate from 
/// @param range {real} how many tiles from the start_node can we move?

function scr_display_action_nodes(start_node, range) {

	#region DISPLAY POSSIBLE MOVES

	//Create lists/priority queue
	var open = ds_priority_create(); //This priority queue holds the id's of nodes we want to check (lowest "combined_distance" will be checked first)
	var closed = []; //We use this because its easier for us to check if the node has already been closed to open queue
	nodes_within_range = []; //array of nodes within "range" of the start_node

	//RESET NODE DATA
	with obj_node{
		_dist = 0;
		_parent = noone;
	}
	
	//Add the start node to the priority queue, this is the first node we want to check (we check its list of neighbours)
	ds_priority_add(open, start_node, start_node._dist);

	var current = noone; //Which node are we going to be checking the neighbours of

	//If there are no nodes in the priority queue, we're done	
	while (ds_priority_size(open) > 0){
	
		current = ds_priority_delete_min(open); //Get the next node from the priority queue
		array_push(closed, current); //Add the node to the "closed" array

		//Get the neighbour array for the current node
		var neighbours = current.nodes_walk;
		
		//This loop runs for as many "neighbours" in the current node's list
		for (var i = 0; i < array_length(neighbours); i ++){
			var adj_node = neighbours[i];
			
			if (array_find(closed, adj_node) == -1){
			
				#region NODE hasn't been checked yet, and (maybe) within range

				adj_node._parent = current;
												
				//If this node hasn't already been added to the open queue AND it's in RANGE, add it
				adj_node._dist = current._dist + 1; 
				
				if (adj_node._dist <= range){
					ds_priority_add(open, adj_node, adj_node._dist);
					array_push(nodes_within_range, adj_node); //We can move to this node
				}
				//Add to closed regardless of whether it's in range or not
				array_push(closed, adj_node);
				
				#endregion

			}else{
				
				#region adj_node already in closed
				
				//Is the current node a better parent?
				if (current._dist + 1 < adj_node._dist){
					adj_node._parent = current;
					adj_node._dist = (current._dist + 1);
				}
				
				#endregion
				
			}
		}
	}

	ds_priority_destroy(open);
	
	return(nodes_within_range);

	#endregion

}
