if (state == e_actor.move){

	#region MOVING

	//If not at target_node coordinates, keep moving
	if (x != target_node.x || y != target_node.y){
		x += sign(target_node.x - x);
		y += sign(target_node.y - y);
		
		//Update coords/level
		grid_x = x div GRID_SIZE;
		grid_y = y div GRID_SIZE;
		level = target_node._level;
	}else{
		//We're at target coords - get next target node
		var prev_node = target_node;
		target_node = scr_get_next_path_node(path);
		
		//Are we at the end of the path? Set to idle
		if (target_node == noone){
			state = e_actor.idle;	
		}else{
			//Let the node we're on know it has an actor
			target_node.actor_id = id;
			//Let previous node know it has no actor
			prev_node.actor_id = noone;	
		}
	}

	#endregion

}
