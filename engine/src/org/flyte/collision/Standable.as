package org.flyte.collision{
	import org.flyte.base.*;
	import org.flyte.motion.MotionTargetedGMC;
	/**
	 * The Standable class is an abstract base for anything that a GameObject might stand on or bounce off of.
	 * @author Ian Reynolds
	 * 
	 */
	public class Standable extends MotionTargetedGMC{
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
         /**
          * The amount of boost a GameObject will be given when jumping off of the object. 
          */         
         public var jumpHeight:Number=0
         /**
          * The amount of restitution a GameObject will experience upon whacking the object with its head, er, sensors.top object. 
          */         
         public var rebound:Number=1
         /**
         * The bounciness of the object
         */
         public var bounce:Number=0

	}
}