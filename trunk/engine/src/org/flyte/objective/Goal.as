package org.flyte.objective
{
	import org.flyte.character.*;
	import org.flyte.events.*;
	import org.flyte.zone.Zone;
	
	/**
	 * A Goal is a Zone object that causes its ScrollWorld to dispatch GameEvent.LEVEL_COMPLETE when the Character enters it. 
	 * Really, that's it. 
	 * @author Ian Reynolds
	 * 
	 */
	public class Goal extends Zone
	{
		public function Goal()
		{
			addEventListener(GameEvent.ENTER,onEnter)
		}
		
		private function onEnter(e:GameEvent):void
		{
			if(e.params.object == Character.current)
			{
				world.dispatchEvent(new GameEvent(GameEvent.LEVEL_COMPLETE))
			}
		}
	}
				
}