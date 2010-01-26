package org.flyte.item
{
	import org.flyte.base.GameMovieClip;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.objective.*;
	public dynamic class Collectible extends GameMovieClip
	{
		public var collected:Boolean=false;
		public var permanent:Boolean=false;
		public var spawnedOnDestroy:Boolean=false;
		protected var owner:GameMovieClip;
		public function Collectible()
		{
			action.mapAction(Action.STILL,"still",nothing);
			action.mapAction(Action.DESTROY,"destroy",_destroy);
			action.setDefault(Action.STILL);
			action.setAction(Action.STILL);
			addLoopListener(onLoop);
		}
		public function setOwner(g:GameMovieClip):void
		{
			if (! g.parent==this.parent)
			{
				throw new Error("Flyte error: the owner of a Collectible must share a parent with the Collectible.");
			} else
			{
				g.addEventListener(GameEvent.DESTROY,onOwnerDestroy);
				this.visible=false;
				spawnedOnDestroy=true;
			}
		}
		private function onOwnerDestroy(e:GameEvent):void
		{
			this.x=GameMovieClip(e.target).x
			this.y=GameMovieClip(e.target).y
			this.visible=true
		}

		private function onLoop(e:GameEvent):void
		{
			if (Collision.hitTestShape(this,Character.current)&&! collected)
			{
				dispatchEvent(new GameEvent(GameEvent.COLLECTED));				
				action.setAction(Action.DESTROY);
				collected=true;
			}
		}
		private function _destroy():void
		{
			if (permanent)
			{
				addResetListener(onReset);
			} else
			{
				GameMovieClip(parent).removeMe(this);
			}
			this.visible=false
		}
		private function onReset(e:GameEvent):void
		{
			action.setAction(Action.STILL);
			collected=false;
			if (this.spawnedOnDestroy)
			{
				visible=false;
			}
		}
		
	}
}