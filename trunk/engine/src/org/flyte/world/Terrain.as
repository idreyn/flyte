package org.flyte.world{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.GameEvent;
	/**
	 * A Terrain object represents something that GameObjects can walk on that may not
	 * be perfectly flat. If you want to make a hill for your character to climb, you would
	 * draw the hill and then convert it to a MovieClip symbol with a base class of Terrain.
	 * The other type of object a GameObject can stand on (Standable) is a Platform, which generally serves
	 * a completely different function, as it checks collisions against its square bounding box
	 * and can be made to move or activate and deactivate periodically.
	 * @author Ian Reynolds
	 * @see org.flyte.base.GameObject
	 * @see org.flyte.collision.Standable
	 * @see org.flyte.world.Platform
	 */
	public class Terrain extends Standable {
		/**
		 * An array of all Terrain objects in a flash movie. Populating this with
		 * objects from outside the current ScrollWorld will not affect performance.
		 * @see org.flyte.world.ScrollWorld
		 */
		public static var enum:Array=new Array();
		protected var rebound:Number=1;
		protected var bounce:Number=0;
		protected var jumpHeight:Number=3;
		private var MAX:Number=0.96;
		private  var MIN:Number=0.6;
		protected var collision:CollisionDictionary;
		public function Terrain() {
			collision=new CollisionDictionary();
			enum.push(this);
			Standable.enum.push(this)
			addLoopListener(onLoop)
		}
		protected override function customReset():void{
			collision.clear();
		}
		private function onLoop(e:GameEvent):void {
			for(var i:uint=0; i<GameObject.enum.length; i++) {
				var t:GameObject=GameObject.enum[i];
				t.sensors.bottom.scaleX=0.96;
				if (Collision.hitTestShape(t.sensors.bottom,this)) {
					if (! collision.isCollisionAt(i,CollisionType.BOTTOM)) {
						collision.setCollisionAt(i,CollisionType.BOTTOM);
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:CollisionType.BOTTOM,sender:this,rebound:this.rebound,bounce:this.bounce,jumpHeight:this.jumpHeight,friction:this.friction}));
					}
					if (!t.jumping && (t.canMoveRight && t.canMoveLeft) && !t.falling) {
						t.sensors.bottom.scaleX=0.25;
						while (Collision.hitTestShape(t.sensors.bottom,this)) {
							t.y--;

						}
						t.y++;

					}
				} else {
					if (collision.isCollisionAt(i,CollisionType.BOTTOM)) {
						collision.endCollisionAt(i,CollisionType.BOTTOM);
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:CollisionType.BOTTOM,sender:this,rebound:this.rebound}));
					}
				}
				t.sensors.left.scaleY=t.sensors.right.scaleY=t.falling?MAX:MIN;
				if (Collision.hitTestShape(t.sensors.right,this)) {
					if (! collision.isCollisionAt(i,CollisionType.RIGHT)) {
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:CollisionType.RIGHT,sender:this,rebound:this.rebound}));
						collision.setCollisionAt(i,CollisionType.RIGHT);
					}
					if (! Collision.hitTestShape(this,t.sensors.left)) {
						while (Collision.hitTestShape(this,t.sensors.right)) {
							t.x--
							;
						}
						t.x++;
					}
				} else {
					if (collision.isCollisionAt(i,CollisionType.RIGHT)) {

						collision.endCollisionAt(i,CollisionType.RIGHT);

						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:CollisionType.RIGHT,sender:this,rebound:this.rebound}));
					}
				}
				if (Collision.hitTestShape(t.sensors.left,this)) {
					if (! collision.isCollisionAt(i,CollisionType.LEFT)) {
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:CollisionType.LEFT,sender:this,rebound:this.rebound}));
						collision.setCollisionAt(i,CollisionType.LEFT);

					}
					if (! Collision.hitTestShape(this,t.sensors.right)) {
						while (Collision.hitTestShape(this,t.sensors.left)) {
							t.x++
							;
						}
						t.x--;
					}
				} else {
					if (collision.isCollisionAt(i,CollisionType.LEFT)) {
						collision.endCollisionAt(i,CollisionType.LEFT);
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:CollisionType.LEFT,sender:this,rebound:this.rebound}));
					}
				}
				if (Collision.hitTestShape(t.sensors.top,this)) {
					if (! collision.isCollisionAt(i,CollisionType.TOP)) {
						collision.setCollisionAt(i,CollisionType.TOP);
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:CollisionType.TOP,sender:this,rebound:this.rebound}));
					}
					if (! Collision.hitTestShape(this,t.sensors.bottom)) {
						while (Collision.hitTestShape(t.sensors.top,this)) {
							t.y++;


						}
					}
				} else {
					if (collision.isCollisionAt(i,CollisionType.TOP)) {
						collision.endCollisionAt(i,CollisionType.TOP);
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:CollisionType.TOP,sender:this,rebound:this.rebound}));
					}
				}

			}
		}
	}
}