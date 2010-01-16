package org.flyte.world{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	public class Surface extends Standable{
		protected var touching:Array;
		protected var type:String=CollisionType.GENERAL;
		public static var surfaces:Array=new Array();
		public function Surface(rebound:Number=0,bounce:Number=0) {
			surfaces.push(this);
			Standable.enum.push(this);
			touching=new Array();

		}
	}
}