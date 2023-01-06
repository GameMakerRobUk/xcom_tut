/// @function scr_generate_path(start_node, end_node, path)
/// @description Generate a path for the actor to move along
/// @param start_node {real} instance_id of the starting node
/// @param end_node {real} instance_id of the node we want to move to
/// @param path {real} the array to store the nodes for the path

function scr_generate_path(start_node, end_node, path) {

	/*
		We already have a list of nodes that are within range, we only need to check these for the best path
	*/

	var current = end_node;
	path = []; //Clear the path
	path[0] = end_node; //The end of the array will be the first node to walk to
	
	while current != start_node{
		
		if (current._parent != noone){																	
			array_push(path, current._parent);
			current = current._parent;		
		}else{																					
			//If this code runs, there's no path to where the actor is trying to get to, so clear the path queue
			//not clearing it means the actor warps to the target cell
			path = [];
			break;	
		}
	}
	
	return(path);
}
