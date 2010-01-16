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
		public var damage:uint=20
		public var damageRadius:Number=300;
		public function Bomb()
		{
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
			action.setAction(Action.DESTROY);
			findBlastRadius();
			_timer.stop()
		}

		private function findBlastRadius():void
		{
			for (var i=0; i<GameObject.enum.length; i++)
			{
				var t:GameObject=GameObject.enum[i];
				if (Math.sqrt(Math.pow(this.x-t.x,2)+Math.pow(this.y-t.y,2))<damageRadius)
				{
					t.dispatchGameEvent(GameEvent.HIT,{sender:this,damage:this.damage,velocity:(this.x>t.x)?-5:5});
				}
			}
		}
	}
}