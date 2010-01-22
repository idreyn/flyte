package blizzard
{
	import org.flyte.character.*;
	import org.flyte.events.*;
	import org.flyte.display.*
	import org.flyte.collision.*;
	import org.flyte.io.*
	import flash.display.*;
	public dynamic class Blizzard extends Character
	{
		public function Blizzard()
		{
			this.pushPower=2.5
			this.lives=3
			this.jumpDampingHold=0.83
			this.attackPower=34
			addEventListener(GameEvent.COLLISION,onCollision);
			addEventListener(GameEvent.ADDED,onAdded)
			showHealthBar=false
		}
		
		private function onCollision(e:GameEvent):void
		{


		}

		private function onAdded(e:GameEvent):void
		{
			action.mapAction(Action.THROW,"toss",nothing);
			world.key.addEventListener(GameEvent.KEY_DOWN,keyDown)
		}
		private function keyDown(e:GameEvent):void
		{
			switch (e.params.key)
			{
				case KeyControls.THROW :
					if (! action.actionInProgress(Action.THROW)&&collisions.bottom>0 && collisions.left == 0 && collisions.right==0)
					{
						action.setAction(Action.THROW);
					}
					break;

			}
		}

	}
}