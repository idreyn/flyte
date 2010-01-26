package org.flyte.utils
{
	import flash.display.*
	import flash.events.*
	import org.flyte.base.Game
	
	public dynamic class Marker extends MovieClip
	{
		public function Marker(x:Number,y:Number,radius:uint=10,color:uint=0xFF0000)
		{
			this.x=x
			this.y=y
			graphics.beginFill(color)
			graphics.drawCircle(0,0,radius)
		}
		
		public static function place(x:Number,y:Number,radius:uint=10,color:uint=0xFF0000):void
		{
			var m:Marker=new Marker(x,y,radius,color)
			Game._root.addChild(m)
		}
	}
}