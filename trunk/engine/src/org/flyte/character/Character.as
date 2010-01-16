package org.flyte.character
{
	import org.flyte.objective.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	import org.flyte.display.*;
	import org.flyte.world.*;
	import org.flyte.utils.*;
	import org.flyte.game.*;
	import org.flyte.base.*;
	import org.flyte.io.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	/**
	 * A Character is the object that the player controls. The semantics of this class is questionable.
	 * It really refers to the "hero" of the game. The character's controls can be set with the key property of the current ScrollWorld.
	 * @see org.flyte.io.KeyControls
	 * @see org.flyte.world.ScrollWorld
	 * @author Ian Reynolds
	 */
	public dynamic class Character extends GameObject
	{
		/**
		 * A reference to the Character in the current ScrollWorld.
		 * Identical to calling Game._root.world.character, but with a lot
		 * less carpal tunnel syndrome.
		 * @see org.flyte.world.ScrollWorld
		 */
		public static var current:Character;
		private var stuckToTerrain:Boolean=false;
		protected var attackInterval:uint=5;
		protected var attackWaiting:Boolean;
		protected var attackWait:uint;
		protected var jumped:uint=0;
		public var acceleration:uint=2;
		public function Character()
		{
			maxVelocityX=30;
			//destroyable=false
			this.addLoopListener(onLoop);
			this.attackPower=34;
			velocityX=0;
			this.faction=FactionManager.GOOD;
			addEventListener(GameEvent.ADDED,added);
			addEventListener(GameEvent.COLLISION,onCollision);
			addEventListener(GameEvent.ATTACK_COMPLETE,onAttackComplete);
			Game._root.world.character=this;
			Game._root.world.dispatchEvent(new GameEvent(GameEvent.CHARACTER_FOUND));
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,onResetLevelE);
			this.healthBar.visible=false;
			//this.sensors.alpha=1
		}
		protected function added(e:GameEvent):void
		{
			world.key.addEventListener(GameEvent.KEY_DOWN,keyDown);
			world.key.addEventListener(GameEvent.KEY_UP,keyUp);
			
		}
		private function onAttackComplete(e:GameEvent):void
		{
			attackWaiting=true;
		}
		protected override function onDie():void
		{
			Game._root.dispatchEvent(new GameEvent(GameEvent.INIT_RESET));
			GameVariables.lives--;
		}
		private function onResetLevelE(e:GameEvent):void
		{
			dead=false;
			attackWaiting=false;
			attacking=false;
		}
		private function onCollision(e:GameEvent):void
		{
			switch (e.params.type)
			{
				case CollisionType.LEFT || CollisionType.RIGHT :
					//velocityX*=(e.params.rebound*-1);
					break;
				case CollisionType.BOTTOM :
					jumped=0;
					stuckToTerrain=true;
					break;

			}
		}
		private function onLoop(e:GameEvent):void
		{

				//this.action.currentActionMovie.scaleX=_md

		}
		protected override function customActions():void
		{
			checkKeys();
			velocityX*=1-(friction/100);
			if (attackWaiting)
			{
				if (attackInterval==attackWait)
				{
					attackWaiting=false;
					attackWait=0;
				}
				attackWait++;
			}
		}

		private function keyDown(e:GameEvent):void
		{
			switch (e.params.key)
			{
				case KeyControls.JUMP :
					if (jumped<GameVariables.maxJumps && jumpReleased)
					{
						stuckToTerrain=false;
						tryJump(jumpHeight);
						jumped++;
					}
					break;

				case KeyControls.RIGHT :
					this.scaleX=originalScaleX
					this.sensors.scaleX=1
					action.setDefault(Action.RUN);
					break;
				case KeyControls.LEFT :
					this.scaleX=originalScaleX*-1
					this.sensors.scaleX=-1
					action.setDefault(Action.RUN);
					break;
			}

		}
		private function keyUp(e:GameEvent):void
		{
			switch (e.params.key)
			{
				case KeyControls.LEFT :
					if (! world.key.isDown(KeyControls.RIGHT))
					{
						action.setDefault(Action.STILL);
					}
					break;
				case KeyControls.RIGHT :
					if (! world.key.isDown(KeyControls.LEFT))
					{
						action.setDefault(Action.STILL);
					}
					break;
			}
		}

		private function checkKeys():void
		{
			velocityX+=rotation/100
			if (world.key.isDown(KeyControls.ATTACK))
			{
				if (! attacking&&! attackWaiting)
				{
					attack();
				}

			}

			action.DEFAULT=(world.key.isDown(KeyControls.LEFT)||world.key.isDown(KeyControls.RIGHT))?Action.RUN:Action.STILL;

			if (world.key.isDown(KeyControls.RIGHT))
			{
				if (Math.abs(velocityX)<=maxVelocityX)
				{
					velocityX+=Math.cos(radians(rotation))*acceleration;
				}
			}
			if (world.key.isDown(KeyControls.LEFT))
			{
				if (Math.abs(velocityX)<=maxVelocityX)
				{
					velocityX-=acceleration;
				}

			}
		}

	}
}