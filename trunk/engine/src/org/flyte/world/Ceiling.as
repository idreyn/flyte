package org.flyte.world{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	public class Ceiling extends Surface {
		public function Ceiling() {
			type=CollisionType.TOP;
			addLoopListener(onLoop)
		}
		private function onLoop(e:GameEvent):void {
			checkCollisions();
		}
		public function checkCollisions():void {
			for (var i:uint=0; i<GameObject.enum.length; i++) {
				//trace(touching[i])
				var t:GameObject=GameObject.enum[i];
				if (Collision.hitTestShape(this,t.sensors.top)) {
					if (! touching[i] && t.collisions.bottom ==0) {
						touching[i]=true;
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:this.type,sender:this,rebound:this.rebound}));
					}
				} else {
					if (touching[i]) {
						touching[i]=false;
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:this.type,sender:this,rebound:this.rebound}));
					}
				}
			}
		}
		public function placeObject(obj:GameObject):void {
			while (Collision.hitTestShape(this,obj.sensors.top)) {
				obj.y++;
			}
			obj.jump=0;
		}

	}
}