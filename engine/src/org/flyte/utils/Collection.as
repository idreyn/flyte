package org.flyte.utils
{
	/**
	 * A Collection is an extension of Array that is designed to prevent multiple indices with the same value.
	 * There has to be a better implementation of this out there somewhere. 
	 * @author Ian Reynolds
	 * 
	 */
	public dynamic class Collection extends Array
	{
		/**
		 * Removes the specified value from the Collection. 
		 * @param i The value to remove.
		 * @return true if the value was removed, false if it was not found inside of the Collection.
		 * 
		 */
		public function remove(i:*):Boolean
		{
			var index:int=this.indexOf(i)
			if(index > -1){
				this.splice(index,index+1)
				return true
			}else{
				return false
			}
		}
		
		/**
		 * Adds a value to the Collection. 
		 * @param i The value to add.
		 * @return true if the value was added, false if it already existed inside of the Collection.
		 * 
		 */
		public function add(i:*):Boolean
		{
			
			var index:int=this.indexOf(i)
			if(index == -1)
			{
				this.push(i)
				return true
			}else{
				return false
			}
		}
	}
}