package org.flyte.motion{
	import org.flyte.base.GameMovieClip;
	import org.flyte.events.GameEvent;
	public class MotionTarget extends GameMovieClip{
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