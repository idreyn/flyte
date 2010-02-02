package org.flyte.utils
{
	import flash.display.*
	import flash.events.*
	import org.flyte.base.Game
	
	/**
	 * A Marker is a little red circle useful for visual debugging. 
	 * @author Ian Reynolds
	 * 
	 */
	public dynamic class Marker extends MovieClip
	{
		/**
		 * Creates a Marker object. 
		 * @param x The x-position of the new Marker.
		 * @param y The y-position of the new Marker.
		 * @param radius The radius of the new Marker.
		 * @param color The color of the new Marker as an integer (e.g., 0x000000).
		 * 
		 */
		public function Marker(x:Number,y:Number,radius:uint=10,color:uint=0xFF0000)
		{
			this.x=x
			this.y=y
			graphics.beginFill(color)
			graphics.drawCircle(0,0,radius)
		}
		
		/**
		 * Places a new Marker on the Game._root object. 
		 * @param x The x-position where the marker will be placed.
		 * @param y The y-position where the marker will be placed.
		 * @param radius The radius of the new Marker.
		 * @param color The color of the new Marker as an integer (e.g., 0x000000).
		 * @see org.flyte.base.Game#_root
		 * 
		 */
		public static function place(x:Number,y:Number,radius:uint=10,color:uint=0xFF0000):void
		{
			var m:Marker=new Marker(x,y,radius,color)
			Game._root.addChild(m)
		}
	}
}