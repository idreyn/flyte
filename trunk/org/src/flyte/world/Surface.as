package flyte.world{
	import flyte.base.*;
	import flyte.collision.*;
	import flyte.events.GameEvent;
	public class Surface extends Standable{
		public var rebound=0;
		protected var touching:Array;
		protected var type:String=CollisionType.GENERAL;
		public static var surfaces:Array=new Array();
		public function Surface(rebound:Number=0,bounce:Number=0) {
			surfaces.push(this);
			touching=new Array();

		}
	}
}