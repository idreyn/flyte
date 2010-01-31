package org.flyte.base
{
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	import org.flyte.world.*;
	import org.flyte.zone.*;
	/**
	 * A SelfControlledGameObject represents any GameObject that moves on its own and,
	 * more importantly, won't fall off the edge of Terrain or a Platform into the abyss.
	 * @see org.flyte.world.Terrain
	 * @see org.flyte.world.Platform
	 * @see GameObject 
	 * @author Ian Reynolds
	 */
	public dynamic class SelfControlledGameObject extends GameObject
	{
		/**
		 * The maximum distance from the game's character (Character.current) that the
		 * object knows the position of the character
		 * @see org.flyte.character.Character#current
		 */
		public var visionRange:Number=300;
		protected var restriction:RestrictionZone;
		/**
		 * Whether the object is restricted by any RestrictionZone objects. 
		 */
		public var restricted:Boolean=false;
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
		/**
		 * How fast the object moves in either direction.
		 */
		public var speed:uint=3;

		public function SelfControlledGameObject()
		{
			addEventListener(GameEvent.ADDED,onAdded);
		}
		private function onAdded(e:GameEvent):void
		{
			determineRestrictionZone();
			world.addEventListener(GameEvent.LOOP,onLoopE);
		}
		private function determineRestrictionZone():void
		{
			for (var i:uint=0; i<RestrictionZone.enum.length; i++)
			{
				if (Collision.hitTestShape(this,RestrictionZone.enum[i]) && RestrictionZone.enum[i] is RestrictionZone)
				{
					restriction=RestrictionZone.enum[i];
					restriction.addEventListener(GameEvent.EXIT,exitRestriction)
					restricted=true
					break;
				}
			}
			//restricted=restriction!=null;
			dispatchEvent(new GameEvent(GameEvent.DETERMINE_RESTRICTION));
		}
		
		private function exitRestriction(e:GameEvent):void
		{
			if(restricted){
				seesCharacter=false
				faceDirection(velocityX>0?-1:1)
				stopCheckingUntilSafe=true;
				lastDistanceFromCharacter=Math.abs(Character.current.x-this.x);

			}
		}
		private function onLoopE(e:GameEvent):void
		{
			//running=velocityX>0.1;
			if (seesEdges)
			{
				checkEdges();
				if (stopCheckingUntilSafe)
				{
					if (leftEdgeHit&&rightEdgeHit)
					{
						stopCheckingUntilSafe=false;
					}
				} else
				{
					if ((! leftEdgeHit || !rightEdgeHit)&&! stopCheckingUntilSafe)
					{
						faceDirection(velocityX>0?-1:1)
						stopCheckingUntilSafe=true;
						seesCharacter=false;
						lastDistanceFromCharacter=Math.abs(Character.current.x-this.x);
					}
				}
			}
			if (! seesCharacter)
			{
				if (Math.abs(Character.current.x-this.x)<lastDistanceFromCharacter)
				{
					seesCharacter=true;
				}
			}

		}
		/**
		 * Causes the object to face left or right. 
		 * @param i The direction to face. Use -1 for left, 1 for right.
		 * 
		 */
		public function faceDirection(i:int,stop:Boolean=false):void
		{
			var s:Number=stop?0:1
			velocityX=i*speed*s;
			if(i != 0) scaleX=i*originalScaleX;
		}

		private function checkEdges():void
		{
			var l:Boolean=false;
			var r:Boolean=false;
			for (var i:uint=0; i<Standable.enum.length; i++)
			{
				var t:*=Standable.enum[i];
				if (Collision.hitTestShape(this.sensors.leftEdge,t))
				{
					l=true;
					break;
				}
			}
			for (i=0; i<Standable.enum.length; i++)
			{
				t=Standable.enum[i];
				if (Collision.hitTestShape(this.sensors.rightEdge,t))
				{
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