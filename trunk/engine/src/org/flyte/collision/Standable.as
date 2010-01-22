package org.flyte.collision{
	import org.flyte.base.*;
	/**
	 * The Standable class just holds an array of all the Terrain and Surface objects in the game.
	 * @author Ian Reynolds
	 * 
	 */
	public class Standable extends GameMovieClip{
		/**
		 * An array of all the Terrain and Surface objects in the game.
		 */
		public static function get enum():Array
		{
			return Game._root.world.standableEnum
		}
		/**
		 * The amount of friction a GameObject encounters when trying to walk on this bad boy.
		 * @see org.flyte.base.GameObject
		 */
		public var friction:Number=15
		public var bounce:Number=0
		public var rebound:Number=1
	}
}