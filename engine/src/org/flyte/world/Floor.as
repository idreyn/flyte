package org.flyte.world
{
	import flash.geom.*;
	import org.flyte.world.*
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	public class Floor extends Surface
	{
		public var bounceX:Number;
		public function Floor()
		{
			type=CollisionType.BOTTOM;
			addEventListener(GameEvent.ADDED,onAdded);
		}
		private function onAdded(e:GameEvent):void
		{
			addLoopListener(onLoop);
		}
		private function onLoop(e:GameEvent):void
		{
			checkCollisions();
		}
		protected override function customReset():void
		{
			clear();
		}
		public function clear():void
		{
			for(var i:uint=0; i<GameObject.enum[i]; i++)
			{
				touching[i]=false;
			}
		}
		private function checkCollisions():void
		{
			for(var i:uint=0; i<GameObject.enum.length; i++)
			{
				var t:GameObject=GameObject.enum[i];
				
				if (Collision.hitTestShape(this,t.sensors.bottom))
				{
					placeObject(t);
					if (! touching[i])
					{
						touching[i]=true;
						t.dispatchEvent(new GameEvent(GameEvent.JUMP,{bounce:parentPlatform.bounce}));
						dispatchEvent(new GameEvent(GameEvent.ENTER_PLATFORM,{index:i,object:t}))
						parent.dispatchEvent(new GameEvent(GameEvent.ENTER_PLATFORM,{index:i,object:t}))
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:this.type,sender:this,rebound:parentPlatform.bounce,bounce:parentPlatform.bounce,bounceX:this.bounceX,jumpHeight:parentPlatform.jumpHeight,friction:parentPlatform.friction}));
					}
				} else
				{
					if (touching[i])
					{
						touching[i]=false;
						dispatchEvent(new GameEvent(GameEvent.LEAVE_PLATFORM,{index:i}));
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:this.type,sender:this}));
					}
				}
			}
		}
		private function placeObject(obj:GameObject):void
		{
			while (Collision.hitTestShape(this,obj.sensors.bottom))
			{
				obj.y--;
			}
			obj.y++;
		}
	}
}