package org.flyte.hud
{
	import org.flyte.base.*
	import org.flyte.events.*;
	import org.flyte.character.Character
	import org.flyte.utils.Lazy;
	import flash.display.*;
	import flash.filters.*
	import caurina.transitions.*
	/**
	 * An HUDHealthBar is a nice little class that is, well, a generic health bar for an HUD object.
	 * Look at the Example.fla file that comes with Flyte for an example. 
	 * @author Ian
	 * 
	 */	
	public class HUDHealthBar extends GameMovieClip
	{
		public function HUDHealthBar()
		{
			addEventListener(GameEvent.ADDED,onAdded);
			Game._root.addEventListener(GameEvent.LOAD,onAdded)
		}
		
		private function onAdded(e:GameEvent):void
		{
			Character.current.addEventListener(GameEvent.HEALTH,onCharacterHit);
		}
		private function onCharacterHit(e:GameEvent):void
		{
			Tweener.addTween(this,{scaleX:Lazy.character.health/100,time:0.5})
		}
	}
}