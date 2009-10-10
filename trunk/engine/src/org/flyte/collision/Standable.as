package org.flyte.collision{
	import org.flyte.base.GameMovieClip;
	/**
	 * The Standable class just holds an array of all the Terrain and Surface objects in the game.
	 * @author Ian Reynolds
	 * 
	 */
	public class Standable extends GameMovieClip{
		/**
		 * An array of all the Terrain and Surface objects in the game.
		 */
		public static var enum:Array=new Array();
		/**
		 * The amount of friction a GameObject encounters when trying to walk on this bad boy.
		 * @see org.flyte.base.GameObject
		 */
		public var friction:Number=15
	}
}