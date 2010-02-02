package org.flyte.zone
{
	import org.flyte.base.GameObject;
	import org.flyte.events.*;
	
	/**
	 * A DeathZone is an ominious-sounding Zone subclass that will kill all GameObjects that enter it. Bwa ha ha!
	 * @author Ian Reynolds
	 * @see org.flyte.base.GameObject
	 */
	public class DeathZone extends Zone
	{
		public function DeathZone()
		{
			addEventListener(GameEvent.ENTER,onEnter)
			addEventListener(GameEvent.EXIT,onExit)
		}
		
		private function onEnter(e:GameEvent):void
		{
			(e.params.object as GameObject).doDie()
		}
		private function onExit(e:GameEvent):void
		{
		}
	}
}