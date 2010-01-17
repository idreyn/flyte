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
			trace("new Blizzard()")
			//This is the line that makes Blizzard fly.
			this.lives=1
			this.jumpDampingHold=1.05 //0.85
			this.attackPower=200
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