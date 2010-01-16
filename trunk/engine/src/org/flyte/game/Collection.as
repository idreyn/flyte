package org.flyte.game
{
	import flash.utils.*;
	public dynamic class Collection extends Object
	{
		public function addItem(d:Class,o:Object){
			var c:String=flash.utils.getQualifiedClassName(d)
			if(!(this[c] is Array)){
				this[c]=new Array()
			}
			var ind:uint=this[c].indexOf(o)
			if(ind == -1){
				this[c].push(o)
			}
		}
		
		public function reset():void
		{
			for(var key:Object in this){
				this[key]=null
			}
		}
		
		public function all(d:Class):Array
		{
			var c:String=flash.utils.getQualifiedClassName(d)
			return this[c] as Array
		}
		
	}
}