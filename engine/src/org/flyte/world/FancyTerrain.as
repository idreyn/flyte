package org.flyte.world
{
	import flash.display.*;
	import flash.geom.*;
	
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.GameEvent;
	import org.flyte.game.*;
	import org.flyte.utils.*;
	/**
	 * A FancyTerrain object is like a Terrain object but it rotates any GameObjects on it to match its slopes.
	 * @author Ian Reynolds
	 * @props Fancy Pants World!
	 * @see org.flyte.base.GameObject
	 * @see org.flyte.collision.Standable
	 * @see org.flyte.world.Terrain
	 */
	public class FancyTerrain extends Standable
	{
	   /**
		 * Whether the FancyTerrain will check collisions. 
		 */		
		public var checkCollisions:Boolean=true
		private var MAX:Number=0.96;
		private var MIN:Number=0.6;
		protected var collision:CollisionDictionary;
		public function FancyTerrain()
		{
			collision=new CollisionDictionary();
			addEventListener(GameEvent.ADDED,onAdded)
		}
		
		private function onAdded(e:GameEvent):void
		{
			Standable.enum.push(this)
			addLoopListener(onLoop);
		}
		protected override function customReset():void
		{
			collision.clear();
		}
		private function onLoop(e:GameEvent=null):void
		{
			if(!checkCollisions || !visible) return
			var all:Array=GameObject.enum;
			for (var i:uint=0; i<all.length; i++)
			{
				var t:GameObject=all[i];
				t.sensors.bottom.scaleX=0.96;
				var left0:Point=t.localToGlobal(new Point(t.bounds.left,t.bounds.bottom));
				var right0:Point=t.localToGlobal(new Point(t.bounds.right,t.bounds.bottom));
				var oLy:Number=left0.y;
				var oRy:Number=right0.y;
				if (this.hitTestPoint(left0.x,left0.y,true)||this.hitTestPoint(right0.x,right0.y,true))
				{
					if (! collision.isCollisionAt(i,CollisionType.BOTTOM))
					{
						collision.setCollisionAt(i,CollisionType.BOTTOM);
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:CollisionType.BOTTOM,sender:this,rebound:this.rebound,bounce:this.bounce,jumpHeight:this.jumpHeight,friction:this.friction}));
					}
					left0=t.localToGlobal(new Point(t.bounds.left,t.bounds.bottom));
					right0=t.localToGlobal(new Point(t.bounds.right,t.bounds.bottom));
					//this.hitTestPoint(left0.x,left0.y,true) || this.hitTestPoint(right0.x,right0.y,true)
					while (this.hitTestPoint(left0.x,left0.y,true) || this.hitTestPoint(right0.x,right0.y,true))
					{
						t.y--;
						left0=t.localToGlobal(new Point(t.bounds.left,t.bounds.bottom));
						right0=t.localToGlobal(new Point(t.bounds.right,t.bounds.bottom));

					}
					t.y++;

					var q:uint=0;
					while (!this.hitTestPoint(left0.x,left0.y,true))
					{
						left0.y++;
						q++;
						if (q>t.width*2)
						{
							return
						}

					}
					q=0;
					while (!this.hitTestPoint(right0.x,right0.y,true))
					{
						q++;
						right0.y++;
						if (q>t.width*2)
						{
							return
						}

					}

					var slope:Number=(left0.y-right0.y)/(left0.x-right0.x);
					t.rotation=degrees(Math.atan(slope));
					
					left0=t.localToGlobal(new Point(t.bounds.left,t.bounds.bottom));
					right0=t.localToGlobal(new Point(t.bounds.right,t.bounds.bottom));
					
					while (this.hitTestPoint(left0.x,left0.y,true) || this.hitTestPoint(right0.x,right0.y,true))
					{
						t.y--;
						left0=t.localToGlobal(new Point(t.bounds.left,t.bounds.bottom));
						right0=t.localToGlobal(new Point(t.bounds.right,t.bounds.bottom));

					}
					t.y++;

				} else
				{
					if (collision.isCollisionAt(i,CollisionType.BOTTOM))
					{
						/*if(!cantFindGround(t)){
						return
						}*/

						collision.endCollisionAt(i,CollisionType.BOTTOM);
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:CollisionType.BOTTOM,sender:this,rebound:this.rebound}));
					}
				}

			}
		}



		private function cantFindGround(t:GameObject):Boolean
		{
			var ly:Number=t.y;
			var left0:Point;
			var right0:Point;
			for (var i:uint=0; i<100; i++)
			{
				t.y++;
				left0=t.localToGlobal(new Point(t.bounds.left,t.bounds.bottom));
				right0=t.localToGlobal(new Point(t.bounds.right,t.bounds.bottom));
				if (this.hitTestPoint(left0.x,left0.y,true)||this.hitTestPoint(left0.x,left0.y,true))
				{
					return false;
				}
			}
			t.y=ly;
			return true;
		}


	}
}