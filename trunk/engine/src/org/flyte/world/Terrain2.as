package org.flyte.world
{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.utils.*;
	import org.flyte.events.GameEvent;
	import flash.geom.*;
	import flash.display.*;
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
	public class Terrain2 extends Standable
	{
		/**
		 * An array of all Terrain objects in a flash movie. Populating this with
		 * objects from outside the current ScrollWorld will not affect performance.
		 * @see org.flyte.world.ScrollWorld
		 */
		public static var enum:Array=new Array();
		protected var jumpHeight:Number=3;
		private var MAX:Number=0.96;
		private var MIN:Number=0.6;
		protected var collision:CollisionDictionary;
		public function Terrain()
		{
			collision=new CollisionDictionary();
			enum.push(this);
			Standable.enum.push(this);
			addLoopListener(onLoop);
		}
		protected override function customReset():void
		{
			collision.clear();
		}
		private function onLoop(e:GameEvent):void
		{
			for (var i:uint=0; i<GameObject.enum.length; i++)
			{
				var t:GameObject=GameObject.enum[i];
				t.sensors.bottom.scaleX=0.96;
				var left0:Point=t.sensors.localToGlobal(new Point(t.sensors.leftPoint.x,t.sensors.leftPoint.y));
				var right0:Point=t.sensors.localToGlobal(new Point(t.sensors.rightPoint.x,t.sensors.rightPoint.y));
		
				if (this.hitTestPoint(left0.x,left0.y,true) || this.hitTestPoint(right0.x,right0.y,true))
				{
					if (! collision.isCollisionAt(i,CollisionType.BOTTOM))
					{
						collision.setCollisionAt(i,CollisionType.BOTTOM);
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:CollisionType.BOTTOM,sender:this,rebound:this.rebound,bounce:this.bounce,jumpHeight:this.jumpHeight,friction:this.friction}));
					}
					stickThis(t);
				} else {
					if (collision.isCollisionAt(i,CollisionType.BOTTOM))
					{
						collision.endCollisionAt(i,CollisionType.BOTTOM);
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:CollisionType.BOTTOM,sender:this,rebound:this.rebound}));
					}
				}

			}
		}

		private function stickThis(t:GameObject,min:uint=5):void
		{
			var left0:Point=t.sensors.localToGlobal(new Point(t.sensors.leftPoint.x,t.sensors.leftPoint.y));
			var right0:Point=t.sensors.localToGlobal(new Point(t.sensors.rightPoint.x,t.sensors.rightPoint.y));
			var leftx:uint=left0.x
			var lefty:uint=left0.y
			for (var i:uint=0; i<100; i++)
			{
				left0.x=leftx+i
				left0.y=lefty+i
				if (this.hitTestPoint(left0.x,left0.y,true))
				{
					break;
				}
				/**left0.x=leftx-i
				left0.y=lefty-i
				if (this.hitTestPoint(left0.x,left0.y,true))
				{
					break;
				}*/
			}
			var rightx:uint=right0.x
			var righty:uint=right0.y
			for (i=0; i<100; i++)
			{
				right0.x=rightx+i
				right0.y=righty+i
				if (this.hitTestPoint(right0.x,right0.y,true))
				{
					break;
				}
				/*
				right0.x=rightx-i
				right0.y=righty-i
				if (this.hitTestPoint(right0.x,right0.y,true))
				{
					break;
				}*/
			}
			var slope:Number=(left0.y-right0.y)/(left0.x-right0.x);
			t.rotation=Math.atan(slope)*(180/Math.PI)
			
			;
		}

		private function cantFindGround(m:GameMovieClip):Boolean
		{
			return true;
		}


	}
}