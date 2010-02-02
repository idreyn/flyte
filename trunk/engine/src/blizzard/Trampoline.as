package blizzard
{
	import flash.events.Event;
	
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.world.*;
	
	/**
	 * @private 
	 * @author Ian
	 * 
	 */
	public class Trampoline extends Platform
	{
		
		public function Trampoline(){
			addEventListener(GameEvent.ADDED,onAdded)
		//	this.setBounce(50,0)
			
		}
		
		
		private function onAdded(e:GameEvent):void
		{
			
			action.mapAction(Action.STILL,"still",nothing)
			action.mapAction(Action.ACTIVATE,"bounce_this",nothing)
			action.setDefault(Action.STILL)
			action.setAction(Action.STILL)
			floor.addEventListener(GameEvent.ENTER_PLATFORM,onEnterPlatform)
		}
		
		private function onEnterPlatform(e:GameEvent):void
		{
			action.setAction(Action.ACTIVATE)
		}
	}
}
		
		
			