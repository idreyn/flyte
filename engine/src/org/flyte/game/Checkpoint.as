package org.flyte.game
{
	import flash.geom.Point;
	
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	/**
	 * Everybody loves checkpoints, because if you die in the game you get to start over at one.
	 * Checkpoints are simple in Flyte. Just put one on the stage and it will happen automatically.
	 * 
	 * Checkpoints require two frame/name combos for their ActionManager: "still" and "activate". 
	 * @author Ian
	 * 
	 */	
	public class Checkpoint extends GameMovieClip
	{	
		/**
		 * A reference to the current Checkpoint, i.e. the last one the Character has passed. 
		 */		
		public static var current:Checkpoint
		
		private var isCurrent:Boolean=false
		
		public function Checkpoint()
		{
			addEventListener(GameEvent.DEACTIVATE,onDeactivateRemote)
			addEventListener(GameEvent.RESET_COMPLETE,onResetComplete)
			action.mapAction(Action.STILL,"still",nothing)
			action.mapAction(Action.ACTIVATE,"activate",nothing,false,false)
			action.setDefault(Action.STILL)
			action.setAction(Action.STILL)
			addLoopListener(onLoop)
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
		/**
		 * Resets the Checkpoint class so there is no current checkpoint. 
		 * 
		 */		
		public static function reset():void
		{
			Checkpoint.current=null
		}
		/**
		 * Gives the position that the Character should return to after dying.
		 * @return The position of the current Checkpoint, or if null, the Character's origin property.
		 * @see org.flyte.base.GameMovieClip#origin
		 * 
		 */		
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