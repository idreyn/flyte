package flyte.collision{
	import flash.utils.Dictionary;
	import flyte.collision.*
	/**
	 * A CollisionDictionary object allows a DisplayObject to keep track of which
	 * GameMovieClips are touching it and how.
	 * @see flyte.base.GameMovieClip
	 * @see flyte.collision.Collision
	 * @see flyte.collision.Sensors
	 * @author Ian Reynolds
	 * 
	 */	
	public class CollisionDictionary{
		private var collisions:Array
		public function CollisionDictionary(){
			collisions=new Array();
		}
		/**
		 * Resets the CollisionDictionary.
		 */
		public function clear():void{
			for(var i:int=0;i<collisions.length;i++){
				collisions[CollisionType.BOTTOM]=false
				collisions[CollisionType.RIGHT]=false
				collisions[CollisionType.LEFT]=false
				collisions[CollisionType.RIGHT]=false
			}
		}
		/**
		 * Retrieves the Boolean value stored at the specified index, with the specified collision type.
		 * @param i The index to retrieve from.
		 * @param type The type of collision to check for at the specified index. Should be a value from CollisionType.
		 * @return A boolean value stored at the specified index
		 * @see CollisionType
		 */
		public function isCollisionAt(i:uint,type:String):Boolean{
			checkExists(i)
			return collisions[i].collides[type]
		}
		/**
		 * Tells the CollisionDictionary to note a collision of a certain type at the specified index. 
		 * @param i The index to record at
		 * @param type The type of collision to record
		 * 
		 */		
		public function setCollisionAt(i:uint,type:String):void{
			checkExists(i)
			collisions[i].collides[type]=true
		}
		/**
		 * Tells the CollisionDictionary to note the end of a collision of a certain type at the specified index. 
		 * @param i The index to record at
		 * @param type The type of collision that has ended, to record
		 * 
		 */		
		public function endCollisionAt(i:uint,type:String):void{
			checkExists(i)
			collisions[i].collides[type]=false
		}
		private function checkExists(i:uint):void{
			if(!(collisions[i] is CollisionReport)){
				collisions[i]=new CollisionReport();
			}
		}
	}
}