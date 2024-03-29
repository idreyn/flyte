﻿package org.flyte.world{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	/**
	 * @private
	 * @author Ian Reynolds
	 * 
	 */
	public class LeftWall extends Surface {
		public function LeftWall() {
			type=CollisionType.RIGHT;
			addLoopListener(onLoop)
		}
		private function onLoop(e:GameEvent):void {
			checkCollisions();
		}
		private function checkCollisions():void {
			for (var i:uint=0; i<GameObject.enum.length; i++) {
				var t:GameObject=GameObject.enum[i];
				if (Collision.hitTestShape(this,t.sensors.right)) {
					if (! touching[i]) {
						touching[i]=true;
						this.parentPlatform.alpha=0
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:this.type,sender:this,rebound:parentPlatform.rebound}));
					}
				if(!Collision.hitTestShape(t,parent)) placeObject(t);
				} else {
					if (touching[i]) {
						touching[i]=false;
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:this.type,sender:this}));
					}
				}
			}
		}
		private function placeObject(obj:GameObject):void {
			while (Collision.hitTestShape(this,obj.sensors.right)) {
				obj.x--;
			}
			obj.x++;
		}
	}
}