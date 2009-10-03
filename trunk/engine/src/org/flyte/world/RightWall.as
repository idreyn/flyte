﻿package flyte.world{
	import flyte.events.*;
	import flyte.collision.*;
	import flyte.world.*;
	import flyte.base.*;
	public class RightWall extends Surface{
		public function Floor() {
			type=CollisionType.LEFT
			addLoopListener(onLoop)
		}
		private function onLoop(e:GameEvent):void {
			checkCollisions();
		}
		private function checkCollisions():void {
			for (var i=0; i<GameObject.enum.length; i++) {
				var t=GameObject.enum[i];
				if (Collision.hitTestShape(this,t.sensors.left)) {
					if (! touching[i]) {
						touching[i]=true;
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:this.type,sender:this,rebound:this.rebound}));
					}
					placeObject(t);
				} else {
					if (touching[i]) {
						touching[i]=false;
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:this.type,sender:this,rebound:this.rebound}));
					}
				}
			}
		}
		private function placeObject(obj:GameObject):void {
			while (Collision.hitTestShape(this,obj.sensors.left)) {
				obj.x++;
			}
			obj.x--;
		}
	}
}