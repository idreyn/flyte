package org.flyte.world{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.GameEvent;
	import org.flyte.game.GameVariables;
	public class Surface extends Standable{
		protected var touching:Array;
		protected var type:String=CollisionType.GENERAL;
		public function Surface(rebound:Number=0,bounce:Number=0) {
			addEventListener(GameEvent.ADDED,onAdded)
			touching=new Array();
		}
		private function onAdded(e:GameEvent):void{
			Standable.enum.push(this)
		}
	}
}