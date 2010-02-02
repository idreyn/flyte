package org.flyte.world
{
	import org.flyte.display.*;
	import org.flyte.events.*;
	
	/**
	 * A Gate is a wrapper for Barrier. It just sort of felt necessary, you know?
	 * @author Ian Reynolds
	 * 
	 */
	public class Gate extends Barrier
	{
		
		public function Gate()
		{
		}
		/**
		 * Open the Gate! 
		 * 
		 */
		public function open():void
		{
			action.setAction(Action.OPEN)
		}
		
		/**
		 * Close the Gate! 
		 * 
		 */
		public function close():void
		{
			action.setAction(Action.CLOSE)
		}
	}
}