package org.flyte.item
{
	import org.flyte.base.GameMovieClip;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.objective.*;
	/**
	 * A Collectible is an object that is collected by the Character when the Character collides with it.
	 * Typical examples would be a coin, health, one-up, et cetera. 
	 * @author Ian
	 * 
	 */
	public dynamic class Collectible extends GameMovieClip
	{
		/**
		 * Whether the Collectible has been collected. 
		 */
		public var collected:Boolean=false;
		/**
		 * Whether the Collectible will reappear when the world resets. 
		 */
		public var permanent:Boolean=false;
		private var spawnedOnDestroy:Boolean=false;
		protected var owner:GameMovieClip;
		public function Collectible()
		{
			action.mapAction(Action.STILL,"still",nothing);
			action.mapAction(Action.DESTROY,"destroy",_destroy);
			action.setDefault(Action.STILL);
			action.setAction(Action.STILL);
			addLoopListener(onLoop);
		}
		/**
		 * Allows you to easily make the Collectible appear as if it was dropped by a GameMovieClip when it dispatches GameEvent.DESTROY.
		 * Basically the Collectible will appear in place of the GameMovieClip. GameObjects automatically dispatch GameEvent.DESTROY when they die,
		 * but you may wish to create your own implementations for treasure chests, etc. Please note that the Enemy class has a dropOnDestroy property that
		 * specifies a collectible to drop when it dies, so you can use that instead. 
		 * @param g The GameMovieClip to listen to.
		 * @param removePrevious Whether to remove the listener for the previous owner. This defaults to true and I recommend you keep it that way.
		 * @see org.flyte.enemy.Enemy#dropOnDestroy
		 */
		public function setOwner(g:GameMovieClip,removePrevious:Boolean=true):void
		{
			if (! g.parent==this.parent)
			{
				throw new Error("Flyte error: the owner of a Collectible must share a parent with the Collectible.");
			} else
			{
				if(owner != null && removePrevious){
					owner.removeEventListener(GameEvent.DESTROY,onOwnerDestroy)
				}
				owner=g
				owner.addEventListener(GameEvent.DESTROY,onOwnerDestroy);
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