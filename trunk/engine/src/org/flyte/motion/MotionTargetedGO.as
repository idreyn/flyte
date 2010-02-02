package org.flyte.motion{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.motion.*;
	import flash.display.*;
	/**
	 * A MotionTargetedGO is a GameObject that uses a MotionTarget. Basically it moves back and forth between the MotionTarget
	 * and its original position. This class is still sort of experimental and it is recommended that you use a RestrictionZone on a 
	 * SelfControlledGameObject for this sort of thing.
	 * @see org.flyte.motion.MotionTarget 
	 * @author Ian Reynolds
	 * 
	 */
	public class MotionTargetedGO extends GameObject{
		/**
		 * Whether the object has a MotionTarget.
		 */
		public var hasTarget:Boolean=false;
		/**
		 * Whether the object is using the motion targeting feature.
		 */
		public var usesTarget:Boolean=false;
		/**
		 * The MotionTarget object to use. 
		 */
		public var motionTarget:MotionTarget;
		private var canContinueTween:Boolean;
		private var motionTargetOriginX:Number;
		private var movementDirectionDefault:int;
		private var returning:Boolean=false;
		private var movingRight:Boolean
		/**
		 * How fast to move. 
		 */
		public var speed:uint=3
		public function MotionTargetedGO() {
			velocityX=3;
			addEventListener(GameEvent.ADDED,onAdded);
			addEventListener(GameEvent.LOOP,loop);
		}
		private function loop(e:GameEvent):void {
			this.velocityX=(this.x>motionTarget.x?-1:1)*speed;
			if ((this.x>motionTarget.x && movingRight) || (this.x<motionTarget.x && !movingRight)) {
				if (motionTargetOriginX==motionTarget.x) {
					motionTarget.x=originX;
					returning=true;
					//movingRight=!(movementDirectionDefault==1)
				} else {
					motionTarget.x=motionTargetOriginX;
					returning=false;
					//movingRight=(movementDirectionDefault==1)

				}
			}
		}

		private function onAdded(e:GameEvent):void {
			if (findMotionTarget()) {
				hasTarget=true;
			} else {
				hasTarget=false;
			}
		}
		/**
		 * Forces the object to re-search for a MotionTarget.
		 * @return Whether a MotionTarget has been found.
		 * 
		 */
		public function findMotionTarget():Boolean {
			var n:String=this.name;
			var c:Boolean=true;
			var has:Boolean=false;
			for(var i:uint=0; i<GameMovieClip.enum.length; i++) {
				var t:DisplayObject=GameMovieClip.enum[i]
				var tn:String=t.name;
				if (tn.slice(0,n.length)==n&&t!=this&&t is MotionTarget) {
					motionTarget=MotionTarget(t);
					movementDirectionDefault=motionTarget.x>this.x?1:-1;
					//movingRight=(movementDirectionDefault==1)
					motionTargetOriginX=motionTarget.x;
					motionTarget.visible=false;
					has=true;
					break;
				}
			}
			return has;
		}

	}
}