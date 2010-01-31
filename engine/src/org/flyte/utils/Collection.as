package org.flyte.utils
{
	public dynamic class Collection extends Array
	{
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