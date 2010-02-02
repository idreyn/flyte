package org.flyte.base
{
	import org.flyte.events.GameEvent;
	
	/**
	 * A TransientObject is destroyed when the world resets. That's really about it. 
	 * @author Ian Reynolds
	 * @see org.flyte.events.GameEvent#RESET_LEVEL
	 */
	public class TransientObject extends GameMovieClip
	{
		/**
		 * Basically the whole purpose of the TransientObject class is to ensure that it doesn't stick around
		 * after the Character dies, which might ruin the illusion of death. 
		 * 
		 */
		public function TransientObject()
		{
			addResetListener(onReset)
		}
		
		private function onReset(e:GameEvent):void
		{
			parent.removeChild(this)
		}
	}
}