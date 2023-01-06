/// @function scr_get_next_path_node(path)
/// @description Get the next node in the path that the actor must travel to
/// @param path (real) the array that holds the nodes to travel to
function scr_get_next_path_node(path) {
	
	if (array_length(path) > 0){
		var priority = array_length(path) - 1;
		var next_node = path[priority];
		array_delete(path, priority, 1);
		
	}else next_node = noone;

	return(next_node);
}
