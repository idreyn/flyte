package org.flyte.projectile
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flyte.base.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.game.*;

	public class Bomb extends Projectile
	{
		
		private var _timer:Timer;
		public var time:uint=3;
		public function Bomb()
		{
			damageRadius=300
			damage=20
			addEventListener(GameEvent.ADDED,onAdded);
			minMaxBounces=100
		}

		private function onAdded(e:GameEvent):void
		{
			_timer=new Timer(time*1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.start();
		}

		private function onTimer(e:TimerEvent):void
		{
			if(!_destroyed){
				destroyThis()
				_timer.stop()
				
			}
		}


	}
}