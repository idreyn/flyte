package org.flyte.world
{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.world.*;
	import org.flyte.collision.*;
	import org.flyte.character.*;
	import org.flyte.display.*;
	/**
	 * An ActivatablePlatform is a Platform object that won't stat moving until the Character steps on it and its needsAccess property is set to false.
	 * Its ActionManager requires two name/frame combos: "normal" and "active". Once "active" is activated the animation will play and stop at the last frame,
	 * so this animation should indicate that the platform is turning on.
	 * @author Ian
	 * 
	 */
	public class ActivatablePlatform extends Platform
	{
		/**
		 * Whether the ActivatablePlatform won't move when stepped on. Go figure. 
		 */
		public var needsAccess:Boolean=false;
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
			action.setAction("active");
		}
		private function loop(e:GameEvent):void
		{
			if (! needsAccess)
			{
				if (Collision.hitTestShape(this.floor,Character.current)&&! activated)
				{
					activated=true
					activateMotion();
					action.setAction(Action.ACTIVATE);
				}
			}
		}
		private function activateFinish():void
		{

		}
	}
}