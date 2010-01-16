package org.flyte.hud
{
	import org.flyte.base.*
	import org.flyte.events.*;
	import org.flyte.character.*;
	import org.flyte.utils.Lazy;
	import flash.display.*;
	import flash.filters.*
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	public class HUDHealthBar extends GameMovieClip
	{
		private var tween:Tween;
		private var t2:Tween;
		public function HUDHealthBar()
		{
			addEventListener(GameEvent.ADDED,onAdded);
		}
		
		private function onAdded(e:GameEvent):void
		{
			Character.current.addEventListener(GameEvent.HEALTH_LOST,onCharacterHit);
		}
		private function onCharacterHit(e:GameEvent):void
		{
			tween=new Tween(this,"scaleX",Elastic.easeOut,this.scaleX,Lazy.character.health/100,0.5,true);
		}
	}
}