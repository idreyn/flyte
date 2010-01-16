package blizzard
{
	import org.flyte.world.*
	import org.flyte.display.*
	import org.flyte.events.*
	import org.flyte.character.*
	import org.flyte.collision.*
	
	public class Trampoline extends TransientPlatform
	{
		
		public function Trampoline(){
			addEventListener(GameEvent.ADDED,onAdded)
			this.setBounce(50,0)
		}
		
		private function onAdded(e:GameEvent):void
		{
			action.mapAction(Action.STILL,"still",nothing)
			action.mapAction(Action.ACTIVATE,"bounce",nothing)
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
		
		
			