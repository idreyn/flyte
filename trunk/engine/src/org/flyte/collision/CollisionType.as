package org.flyte.collision{
	/**
	 * The CollisionType class just holds a bunch of constants denoting different
	 * types of collisions that can occur with Sensors objects.
	 * @author Ian Reynolds
	 * 
	 */	
	public class CollisionType {
		/**
		 * Denotes a collision with the top of a Sensors object.
		 * @see Sensors
		 */
		public static const TOP:String="collisionTop";
		/**
		 * Denotes a collision with the left side of a Sensors object.
		 * @see Sensors
		 */
		public static const LEFT:String="collisionLeft";
		/**
		 * Denotes a collision with the right side of a Sensors object.
		 * @see Sensors
		 */
		public static const RIGHT:String="collisionRight";
		/**
		 * Denotes a collision with the bottom of a Sensors object.
		 * @see Sensors
		 */
		public static const BOTTOM:String="collisionBottom";
		/**
		 * Denotes a radial collision (unused).
		 * @see Sensors
		 */
		public static const RADIAL:String="collisionRadial";
		/**
		 * Denotes any old collision
		 * @see Sensors
		 */
		public static const GENERAL:String="collisionGeneral";
		/**
		 * Denotes a collision with the sensor extending behind and below a GameMovieClip
		 * that checks for ledges.
		 * @see Sensors
		 * @see org.flyte.base.GameMovieClip
		 */
		public static const LEFT_EDGE:String="collisionLeftEdge";
		/**
		 * Denotes a collision with the sensor extending in front of and below a GameMovieClip
		 * that checks for ledges.
		 * @see Sensors
		 * @see org.flyte.base.GameMovieClip
		 */
		public static const RIGHT_EDGE:String="collisionRightEdge";
	}
}