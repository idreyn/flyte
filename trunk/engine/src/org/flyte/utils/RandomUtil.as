package org.flyte.utils
{
	/**
	 * The RandomUtil class provides a couple of neat shortcuts for common uses of Math.random(). 
	 * @author Ian Reynolds
	 * 
	 */
	public class RandomUtil
	{
		/**
		 * Returns a random integer between the min and max values. 
		 * @param min The minimum value allowed.
		 * @param max The maximum value allowed.
		 * @return A random integer!
		 * 
		 */
		public static function randomInt(min:int,max:int):int
		{
			return Math.round(Math.random()*(max-min))+min;
		}
		/**
		 * Gives a random boolean, true or false. 
		 * @return A random Boolean!
		 * 
		 */
		public static function randomBoolean():Boolean
		{
			return Math.random()>0.5;
		}
		/**
		 * Chooses a random item from the specified array. 
		 * @param a The array to choose a random item from.
		 * @return A random item from the specified array.
		 * 
		 */
		public static function randomIndex(a:Array):*
		{
			return a[RandomUtil.randomInt(0,a.length-1)];
		}
	}
}