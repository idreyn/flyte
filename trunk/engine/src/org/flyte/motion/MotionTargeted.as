package org.flyte.motion{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.events.*;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	
	/**
	 * A MotionTargeted object moves back and forth between its MotionTarget and its original position.
	 * To specify the MotionTarget to use, start the name of the MotionTarget object with the name of the MotionTargeted object.
	 * For example to make a platform called "bounce" move to a target, name the MotionTarget "bounce_target" or something. 
	 * @props to Tweener!
	 * @author Ian Reynolds
	 * @see org.flyte.motion.MotionTarget
	 */
	public class MotionTargeted extends GameMovieClip{
		/**
		 * Whether the MotionTargeted has a MotionTarget. 
		 */
		public var hasTarget:Boolean=false;
		/**
		 * Whether the MotionTargeted uses motion targeting. 
		 */
		public var usesTarget:Boolean=false;
		/**
		 * A reference to the object's MotionTarget. 
		 */
		public var motionTarget:MotionTarget;
		/**
		 * The length of time for the object to move to and from the target. 
		 */
		public var time:Number
		/**
		 * The type of tween to use. For best results, keep it at "linear".
		 * @see http://hosted.zeh.com.br/tweener/docs/en-us/misc/transitions.html 
		 */
		public var tweenType:*="linear"
		protected var activated:Boolean=true
		public function MotionTargeted() {
			addEventListener(GameEvent.ADDED,onAdded);
		}
		private function onAdded(e:GameEvent):void {
			if (findMotionTarget()) {
				hasTarget=true;
				if(activated){
					startMotion();
				}
			} else {
				hasTarget=false;
			}
		}
		/**
		 * Starts the motion of the MotionTargeted object. 
		 * 
		 */
		public function activateMotion():void{
			if(hasTarget){
				startMotion()
			}
		}
		private function startMotion():void {
			velocityX=3
			var m:MotionTarget=this.motionTarget
			if(!time>0) time=Math.sqrt(Math.pow(m.x-this.x,2)+Math.pow(m.y-this.y,2))/velocityX/stage.frameRate;
			Tweener.addTween(this,{x:m.x,y:m.y,time:this.time,onComplete:tweenComplete,transition:tweenType})
		}
		private function tweenComplete():void {
			Tweener.addTween(this,{x:this.originX,y:this.originY,time:this.time,onComplete:startAgain,transition:tweenType})
			
		}
		
		private function startAgain():void
		{
			Tweener.addTween(this,{x:motionTarget.x,y:motionTarget.y,time:this.time,onComplete:tweenComplete,transition:tweenType})
		}
		
		/**
		 * Stops the motion of the MotionTargeted object. 
		 * 
		 */
		public function stopMotion():void
		{
			Tweener.removeTweens(this)
			Tweener.addTween(this,{x:this.originX,y:this.originY,time:1,transition:tweenType})
		}
			

			
		/**
		 * Forces the MotionTargeted to look for a MotionTargeted again. 
		 * @return Whether one has been found.
		 * 
		 */
		public function findMotionTarget():Boolean {
			var n:String=this.name;
			var c:Boolean=true;
			var has:Boolean=false;
			for(var i:uint=0; i<parent.numChildren; i++) {
				var t:DisplayObject=parent.getChildAt(i);
				var tn:String=t.name;
				if (tn.slice(0,n.length)==n&&t!=this&&t is MotionTarget) {
					motionTarget=MotionTarget(t);
					motionTarget.visible=false;
					has=true;
					break;
				}
			}
			return has;
		}

	}
}