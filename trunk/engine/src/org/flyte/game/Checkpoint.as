package org.flyte.game
{
	import flash.geom.Point;
	
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	
	public class Checkpoint extends GameMovieClip
	{
		public static var enum:Array=new Array()
		
		private static var current:Checkpoint
		
		private var isCurrent:Boolean=false
		
		public function Checkpoint()
		{
			Checkpoint.enum.push(this)
			addLoopListener(onLoop)
			addEventListener(GameEvent.DEACTIVATE,onDeactivateRemote)
			addEventListener(GameEvent.RESET_COMPLETE,onResetComplete)
			action.mapAction(Action.STILL,"still",nothing)
			action.mapAction(Action.ACTIVATE,"activate",nothing,false,false)
			action.setDefault(Action.STILL)
			action.setAction(Action.STILL)
		}
		
		private function onLoop(e:GameEvent):void
		{
			if(Collision.hitTestShape(this,Character.current) && ! this.isCurrent)
			{
				isCurrent=true
				
				if(Checkpoint.current != null){
					Checkpoint.current.dispatchEvent(new GameEvent(GameEvent.DEACTIVATE))
				}
				Checkpoint.current=this
				action.setAction(Action.ACTIVATE)
			}
		}
		
		private function onDeactivateRemote(e:GameEvent):void
		{
			isCurrent=false
			action.setAction(Action.STILL)
		}
		
		private function onResetComplete(e:GameEvent):void
		{
			if(isCurrent){
				action.setAction(Action.ACTIVATE)
			}
		}
		
		public static function reset():void
		{
			Checkpoint.current=null
		}
		public static function getPosition():Point
		{
			if(Checkpoint.current == null){
				return Character.current.origin
			}else{
				return Checkpoint.current.position
			}
		}
				
		
	}
}