package flyte.enemy{
	import flyte.base.*;
	import flyte.character.*;
	import flyte.collision.*;
	import flyte.display.*;
	import flyte.events.GameEvent;
	import flyte.zone.*;
	public class Enemy extends AbstractEnemy {
		public static var attackingTotal:uint=0;
		public static var MAX_ATTACK_CHARACTER:uint=3;
		public var onCharacter:Boolean=false;
		public var respawnAfterReset:Boolean=true;
		public var speed:uint=3;
		protected var moving:Boolean=true;
		protected var grace:uint;
		private var _externalVelocity:Number
		public function Enemy() {
			originLives=this.lives=1;
			this.attackPower=17;
			addEventListener(GameEvent.HIT,ohit);
			addEventListener(GameEvent.ADDED,onAdded);
		}
		public function set velocity(i:Number):void
		{
			//Allows the Enemy's velocity to be
			_externalVelocity=i;
		}
			
		private function onAdded(e:GameEvent):void {
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,onResetLevel);
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
			velocityX=speed;
		}
		private function determineRestriction()
		{
			
		}
		private function ohit(e:GameEvent):void{
		}
		private function onResetLevel(e:GameEvent):void {
			if (! respawnAfterReset&&dead) {
				stopListening();
			}
			grace=0
			onCharacter=false;
			dead=false;
				
			addEventListener(GameEvent.DETERMINE_RESTRICTION,onDetermineRestriction);
		}
		private function onDetermineRestriction(e:GameEvent):void {
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
		}
		private function onLoopE(e:GameEvent):void {
			onCharacter=Collision.hitTestShape(Character.current,this);
			if (! stopCheckingUntilSafe&&seesCharacter) {
				velocityX=(onCharacter?0:this.x>=Character.current.x?-1:1)*speed
			}
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