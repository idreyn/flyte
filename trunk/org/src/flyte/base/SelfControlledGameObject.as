package flyte.base{
	import flyte.base.*;
	import flyte.world.*;
	import flyte.character.*;
	import flyte.events.*;
	import flyte.collision.*;
	import flyte.zone.*;
	/**
	 * A SelfControlledGameObject represents any GameObject that moves on its own and,
	 * more importantly, won't fall off the edge of Terrain or a Platform into the abyss.
	 * @see flyte.world.Terrain
	 * @see flyte.world.Platform
	 * @see GameObject 
	 * @author Ian Reynolds
	 */	
	public dynamic class SelfControlledGameObject extends GameObject {
		/**
		 * The maximum distance from the game's character (Character.current) that the
		 * object knows the position of the character
		 * @see flyte.character.Character#current
		 */
		public var visionRange:Number=300;
		protected var restriction:RestrictionZone;
		protected var restricted:Boolean=false;
		/**
		 * Whether the object bothers to look before it leaps. If set to true, it will not
		 * walk off a ledge.
		 */
		public var seesEdges:Boolean=true;
		protected var seesCharacter:Boolean=false;
		protected var lastDistanceFromCharacter:Number=visionRange;
		private var leftEdgeHit:Boolean=false;
		private var rightEdgeHit:Boolean=false;
		private var avoidFallLeft:Boolean=false;
		private var avoidFallRight:Boolean=false;
		protected var stopCheckingUntilSafe:Boolean=false;

		public function SelfControlledGameObject() {
			addEventListener(GameEvent.ADDED,onAdded);
		}
		private function onAdded(e:GameEvent):void {
			determineRestrictionZone();
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
		}
		private function determineRestrictionZone():void {
			for (var i=0; i<RestrictionZone.enum.length; i++) {
				if (Collision.hitTestShape(this,RestrictionZone.enum[i])) {
					restriction=RestrictionZone.enum[i];
					break;
				}
			}
			//restricted=restriction!=null;
			dispatchEvent(new GameEvent(GameEvent.DETERMINE_RESTRICTION));
		}
		private function onLoopE(e:GameEvent):void {
			//running=velocityX>0.1;
			if (seesEdges) {
				checkEdges();
				if (stopCheckingUntilSafe) {
					if (leftEdgeHit&&rightEdgeHit) {
						stopCheckingUntilSafe=false;
					}
				} else {
					if ((! leftEdgeHit || !rightEdgeHit)&&! stopCheckingUntilSafe) {
						this.velocityX*=-1;
						stopCheckingUntilSafe=true;
						seesCharacter=false;
						lastDistanceFromCharacter=Math.abs(Character.current.x-this.x);
					}
				}
			}
			if (! seesCharacter) {
				if (Math.abs(Character.current.x-this.x)<lastDistanceFromCharacter) {
					seesCharacter=true;
				}
			}

		}
		private function checkEdges():void {
			var l=false;
			var r=false;
			for (i=0; i<Standable.enum.length; i++) {
				t=Standable.enum[i];
				if (Collision.hitTestShape(this.sensors.leftEdge,t)) {
					l=true;
					break;
				}
			}
			for (var i=0; i<Standable.enum.length; i++) {
				var t=Standable.enum[i];
				if (Collision.hitTestShape(this.sensors.rightEdge,t)) {
					r=true;
					break;
				}
			}
			leftEdgeHit=l;
			rightEdgeHit=r
			;
		}
	}
}