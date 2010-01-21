package org.flyte.enemy
{
	import org.flyte.base.*;
	import org.flyte.display.*;
	import org.flyte.events.GameEvent;
	import org.flyte.collision.*;
	import org.flyte.character.*;
	public class Enemy extends AbstractEnemy
	{
		public static var attackingTotal:uint=0;
		public static var MAX_ATTACK_CHARACTER:uint=3;
		public var onCharacter:Boolean=false;
		public var respawnAfterReset:Boolean=true;

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
		private function onResetLevel(e:GameEvent):void
		{
			if (! respawnAfterReset&&dead)
			{
				stopListening();
			}
			addEventListener(GameEvent.DETERMINE_RESTRICTION,onDetermineRestriction);
		}
		private function onDetermineRestriction(e:GameEvent):void
		{
			world.addEventListener(GameEvent.LOOP,onLoopE);
		}
		private function checkPosition(e:GameEvent):void
		{
			if (seesCharacter)
			{
				faceDirection(this.x>Character.current.x?-1:1);
			}

		}
		private function onLoopE(e:GameEvent):void
		{
			onCharacter=Collision.hitTestShape(this,Character.current);
			moves=! onCharacter;
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