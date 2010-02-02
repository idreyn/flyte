package org.flyte.world{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.GameEvent;
	/**
	 * @private 
	 * @author Ian Reynolds
	 * 
	 */
	public class Surface extends GameMovieClip{
		protected var touching:Array;
		protected var parentPlatform:Platform
		protected var type:String=CollisionType.GENERAL;
		public function Surface(rebound:Number=0,bounce:Number=0) {
			touching=new Array();
			addEventListener(GameEvent.ADDED,onAdded)
		}
		
		private function onAdded(e:GameEvent):void{
			parentPlatform=Platform(parent)
		}
	}
}