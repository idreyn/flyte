package org.flyte.enemy
{
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.GameEvent;
	import org.flyte.item.Collectible;
	/**
	 * An Enemy is just that. Not a very nice GameObject. There isn't too much to the enemy class, and if you're
	 * serious about creating your own game, you might want to consider writing your own. 
	 * @author Ian
	 * 
	 */
	public class Enemy extends AbstractEnemy
	{
		/**
		 * Whether the Enemy is touching the current Character. 
		 */		
		public var onCharacter:Boolean=false;
		/**
		 * Whether the Enemy, if dead, will respawn when the world resets (when the Character dies).
		 */		
		public var respawnAfterReset:Boolean=true;
		/**
		 * A Collectible object that, if non-null, the Enemy will "drop" when it dies. 
		 */		
		public var dropOnDie:Collectible=null
		private var r2c:Boolean=false;
		private var lastVelX:Number;
		protected var moving:Boolean=true;
		protected var grace:uint=31;
		public function Enemy()
		{
			originLives=this.lives=1;
			this.attackPower=17;
			addEventListener(GameEvent.HIT,ohit);
			addEventListener(GameEvent.ADDED,onAdded);
			addEventListener(GameEvent.DIE,onDie);
			addLoopListener(checkPosition);
		}
		private function onAdded(e:GameEvent):void
		{
			world.addEventListener(GameEvent.RESET_LEVEL,onResetLevel);
			world.addEventListener(GameEvent.LOOP,onLoopE);
			velocityX=speed*(this.x>Character.current.x?-1:1);
		}
		private function ohit(e:GameEvent):void
		{

		}
		
		private function onDie(e:GameEvent):void
		{
			if(dropOnDie != null){
				parent.addChild(dropOnDie)
			}
		}
		private function onResetLevel(e:GameEvent):void
		{
			action.reset()
			if (! respawnAfterReset&&dead)
			{
				stopListening();
			}else{
				dead=false
			}
			addEventListener(GameEvent.DETERMINE_RESTRICTION,onDetermineRestriction);
		}
		private function onDetermineRestriction(e:GameEvent):void
		{
			world.addEventListener(GameEvent.LOOP,onLoopE);
		}
		private function checkPosition(e:GameEvent):void
		{ 
			onCharacter=Collision.hitTestShape(this,Character.current)
			if (seesCharacter && !action.actionInProgress(Action.DIE))
			{
				faceDirection(this.x>Character.current.x?-1:1,onCharacter);
			}else{
				faceDirection(this.velocityX>0?1:-1)
			}

		}
		private function onLoopE(e:GameEvent):void
		{
			action.DEFAULT=(Math.abs(velocityX)>0.5)?Action.RUN:Action.STILL;
			if (onCharacter&&grace>30)
			{
				attack();
				grace=0;
			} else
			{
				grace++;


			}

		}

	}
}