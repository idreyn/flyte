package org.flyte.enemy{
	import org.flyte.base.*;
	import org.flyte.display.*;
	import org.flyte.events.GameEvent;
	import org.flyte.collision.*;
	import org.flyte.character.*;
	public class Enemy extends AbstractEnemy {
		public static var attackingTotal:uint=0;
		public static var MAX_ATTACK_CHARACTER:uint=3;
		public var onCharacter:Boolean=false;
		public var respawnAfterReset:Boolean=true;
		public var speed:uint=3;
		private var r2c:Boolean=false;
		private var lastVelX:Number;
		protected var moving:Boolean=true;
		protected var grace:uint=31;
		public function Enemy() {
			originLives=this.lives=1;
			this.attackPower=17;
			addEventListener(GameEvent.HIT,ohit);
			addEventListener(GameEvent.ADDED,onAdded);
			addLoopListener(checkPosition);
		}
		private function onAdded(e:GameEvent):void {
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,onResetLevel);
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
			velocityX=speed;
		}
		private function ohit(e:GameEvent):void {
			trace("I've been hit!",this.health);

		}
		private function onResetLevel(e:GameEvent):void {
			if (! respawnAfterReset&&dead) {
				stopListening();
			}
			addEventListener(GameEvent.DETERMINE_RESTRICTION,onDetermineRestriction);
		}
		private function onDetermineRestriction(e:GameEvent):void {
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
		}
		private function checkPosition(e:GameEvent):void {

			if (this.x>Character.current.x && !hurting){
				if (! r2c && !onCharacter) {
					r2c=true;
					velocityX*=-1;
					scaleX=originalScaleX*-1
				}
			} else {
				if (r2c && !onCharacter) {
					r2c=false;
					velocityX*=-1;
					scaleX=originalScaleX*1
				}
			}

		}
		private function onLoopE(e:GameEvent):void {
			onCharacter=Collision.hitTestShape(this,Character.current);
			moves=!onCharacter
			action.DEFAULT=(Math.abs(velocityX)>0.5)?Action.RUN:Action.STILL;
			if (onCharacter&&grace>30) {
				attack();
				grace=0;
			} else {
				grace++;


			}

		}


	}
}