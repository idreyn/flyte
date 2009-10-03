package flyte.world
{
	import flyte.base.*;
	import flyte.events.*;
	import flyte.world.*;
	import flyte.collision.*;
	public class Floor extends Surface
	{
		public var jumpHeight:Number;
		public var bounce:Number;
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
			for (var i=0; i<GameObject.enum[i]; i++)
			{
				touching[i]=false;
			}
		}
		private function checkCollisions():void
		{
			for (var i=0; i<GameObject.enum.length; i++)
			{
				var t=GameObject.enum[i];
				if (Collision.hitTestShape(this,t.sensors.bottom))
				{
					placeObject(t);
					if (! touching[i])
					{
						touching[i]=true;
						t.dispatchEvent(new GameEvent(GameEvent.JUMP,{bounce:this.bounce}));
						dispatchEvent(new GameEvent(GameEvent.ENTER_PLATFORM,{index:i}));
						t.dispatchEvent(new GameEvent(GameEvent.COLLISION,{type:this.type,sender:this,rebound:this.rebound,bounce:this.bounce,bounceX:this.bounceX,jumpHeight:this.jumpHeight,friction:this.friction}));
					}
				} else
				{
					if (touching[i])
					{
						touching[i]=false;
						dispatchEvent(new GameEvent(GameEvent.LEAVE_PLATFORM,{index:i}));
						t.dispatchEvent(new GameEvent(GameEvent.END_COLLISION,{type:this.type,sender:this,rebound:this.rebound,bounce:this.bounce,bounceX:this.bounceX,jumpHeight:this.jumpHeight}));
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