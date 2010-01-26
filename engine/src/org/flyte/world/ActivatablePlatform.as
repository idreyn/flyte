package org.flyte.world
{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.world.*;
	import org.flyte.collision.*;
	import org.flyte.character.*;
	import org.flyte.display.*;
	public class ActivatablePlatform extends Platform
	{
		public var access:Boolean=false;
		public function ActivatablePlatform()
		{
			activated=false;
			addEventListener(GameEvent.ADDED,onAdded);

		}
		private function onAdded(e:GameEvent):void
		{
			addLoopListener(loop);
			action.mapAction(Action.ACTIVATE,"active",activateFinish,false,false);
			action.mapAction(Action.NORMAL,"normal",nothing);
			//action.setDefault(Action.NORMAL);
			action.setAction("active");
		}
		private function loop(e:GameEvent):void
		{
			if (! access)
			{
				if (Collision.hitTestShape(this.floor,Character.current)&&! activated)
				{
					activated=true
					activate();
					action.setAction(Action.ACTIVATE);
				}
			}
		}
		private function activateFinish():void
		{

		}
	}
}