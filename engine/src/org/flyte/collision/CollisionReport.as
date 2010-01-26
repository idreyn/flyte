package org.flyte.collision{
	import org.flyte.collision.CollisionType
	import flash.utils.Dictionary
	/**
	 * A CollisionReport simply contains a Dictionary with indexes at several values of CollisionType.
	 * There's very little use for this class, and it's basically a helper to CollisionDictionary. 
	 * @author Ian Reynolds
	 * 
	 */	
	public class CollisionReport{
		/**
		 * The dictionary with indexes at CollisionType.RIGHT, LEFT, TOP, and BOTTOM.
		 */
		public var collides:Dictionary;
		public function CollisionReport() {
			collides=new Dictionary();
			collides[CollisionType.RIGHT]=false;
			collides[CollisionType.LEFT]=false;
			collides[CollisionType.TOP]=false;
			collides[CollisionType.BOTTOM]=false;
		}
	}
}