package org.flyte.motion{
	import org.flyte.base.GameMovieClip;
	import org.flyte.events.GameEvent;
	/**
	 * The MotionTarget class represents an object in a ScrollWorld that a MotionTargeted object will use as its target.
	 * That basically means the MotionTargeted will move back and forth between the target and its original position.
	 * @author Ian Reynolds
	 * @see org.flyte.motion.MotionTargeted
	 */
	public class MotionTarget extends GameMovieClip{
		/**
		 * Deprecated, methinks. 
		 */
		public static var enum:Array=new Array();
		
		public function MotionTarget()
		{
			addEventListener(GameEvent.RESET_COMPLETE,onResetComplete)
			
		}
		
		private function onResetComplete(e:GameEvent):void
		{
			this.visible=false
		}
		
	}
}