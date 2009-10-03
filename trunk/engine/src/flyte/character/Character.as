package flyte.character{
	import flyte.objective.*;
	import flyte.collision.*;
	import flyte.events.*;
	import flyte.display.*;
	import flyte.world.*;
	import flyte.utils.*;
	import flyte.game.*;
	import flyte.base.*;
	import flyte.io.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.motion.Tweenables;
	/**
	 * A Character is the object that the player controls. The semantics of this class is questionable.
	 * It really refers to the "hero" of the game. The character's controls can be set with the key property of the current ScrollWorld.
	 * @see flyte.io.KeyControls
	 * @see flyte.world.ScrollWorld
	 * @author Ian Reynolds
	 */
	public dynamic class Character extends GameObject {
		public static var current:Character;
		protected var attackInterval:uint=5;
		protected var attackWaiting:Boolean;
		protected var attackWait:uint;
		protected var jumped:uint=0;
		public function Character() {
			//destroyable=false
			this.attackPower=34;
			velocityX=0;
			this.faction=FactionManager.GOOD;
			addEventListener(GameEvent.ADDED,added);
			addEventListener(GameEvent.COLLISION,onCollision);
			Game._root.world.character=this;
			Game._root.world.dispatchEvent(new GameEvent(GameEvent.CHARACTER_FOUND));
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,onResetLevelE);
			this.healthBar.visible=false
		}
		protected function added(e:GameEvent):void {
			world.key.addEventListener(GameEvent.KEY_DOWN,keyDown);
			world.key.addEventListener(GameEvent.KEY_UP,keyUp);
		}
		protected override function onAttackComplete():void {
			attackWaiting=true;
		}
		protected override function onDie():void {
			Game._root.dispatchEvent(new GameEvent(GameEvent.INIT_RESET));
			GameVariables.lives--;
		}
		private function onResetLevelE(e:GameEvent):void {
			dead=false;
			attackWaiting=false;
			attacking=false;
		}
		protected function onCollision(e:GameEvent):void {
			switch (e.params.type) {
				case CollisionType.LEFT || CollisionType.RIGHT :
					velocityX*=(e.params.rebound*-1);
					break;
				case CollisionType.BOTTOM :
					jumped=0;

			}
		}
		protected override function customActions():void {
			checkKeys();
			velocityX*=1-(friction/100);
			if (attackWaiting) {
				if (attackInterval==attackWait) {
					attackWaiting=false;
					attackWait=0;
				}
				attackWait++;
			}
		}

		private function keyDown(e:GameEvent):void {
			switch (e.params.key) {
				case KeyControls.JUMP :
					if (jumped<GameVariables.maxJumps) {
						tryJump(jumpHeight);
						jumped++;
					}
					//action.setAction(Action.JUMP)
					break;
				case KeyControls.RIGHT:   
					action.setDefault(Action.RUN);
					break;
				case KeyControls.LEFT :
					action.setDefault(Action.RUN);
					break;
			}

		}
		private function keyUp(e:GameEvent):void {
			switch (e.params.key) {
				case KeyControls.LEFT:
					if (! world.key.isDown(KeyControls.RIGHT)) {
						action.setDefault(Action.STILL);
					}
					break;
				case KeyControls.RIGHT :
					if (! world.key.isDown(KeyControls.LEFT)) {
						action.setDefault(Action.STILL);
					}
					break;
			}
		}

		private function checkKeys():void {
			if (world.key.isDown(KeyControls.ATTACK)) {
				if (! attacking&&! attackWaiting) {
					attack();
					trace("try attack from Character::checkKeys()");
				}

			}
			action.DEFAULT=(world.key.isDown(KeyControls.LEFT)||world.key.isDown(KeyControls.RIGHT))?Action.RUN:Action.STILL;

			if (world.key.isDown(KeyControls.RIGHT)) {
				if (Math.abs(velocityX)<=maxVelocityX) {
					velocityX++;
				}
			}
			if (world.key.isDown(KeyControls.LEFT)) {
				if (Math.abs(velocityX)<=maxVelocityX) {
					velocityX--;
				}

			}
		}

	}
}