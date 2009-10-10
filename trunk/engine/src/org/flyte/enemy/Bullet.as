package org.flyte.enemy{
	import org.flyte.display.*;
	import org.flyte.events.GameEvent;
	import org.flyte.projectile.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	public class Bullet extends Projectile{
		public static var FRIENDLY_FIRE:Boolean=false
		public var faction:String
		public var damage:uint
		public function Bullet(f:String){
			this.faction=f
			addEventListener(GameEvent.ADDED,onAdded)
			action.mapAction(Action.NORMAL,"normal",nothing)
			action.mapAction(Action.DESTROY,"destroy",removeThis)
			action.setDefault(Action.NORMAL)
			action.setAction(Action.NORMAL)
		}
		private function onAdded(e:GameEvent):void{
			addLoopListener(loop)
		}
		protected function loop(e:GameEvent):void{
			if(this.faction!=Character.current.faction){
				if(Collision.hitTestShape(this,Character.current)){
					Character.current.dispatchEvent(new GameEvent(GameEvent.HIT,{damage:this.damage}))
					action.setAction(Action.DESTROY)
					velocityX=velocityY=0;
				}
			}
		}
		private function removeThis():void{
			container.removeMe(this)
		}
	}
}
					
					