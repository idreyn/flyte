package org.flyte.world
{
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.objective.IActivatable;
	public class Gate extends Barrier implements IActivatable
	{
		
		public function Gate()
		{
			addActivateTargetableListeners()
		}
		public function open():void
		{
			action.setAction(Action.OPEN)
		}
		
		public function close():void
		{
			action.setAction(Action.CLOSE)
		}
	}
}