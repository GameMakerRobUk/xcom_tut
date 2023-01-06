function array_find(array, value){
   //Return -1 if not found, or entry number if found
   
   var found = -1;
   
   for (var i = 0; i < array_length(array); i ++){
	   if (array[i] == value){
			found = i;
			break;
	   }
   }
   return(found);
}