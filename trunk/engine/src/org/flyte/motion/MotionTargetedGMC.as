package org.flyte.motion{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.events.*;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	
	public class MotionTargetedGMC extends GameMovieClip implements IMotionTargetable{
		public var hasTarget:Boolean=false;
		public var usesTarget:Boolean=false;
		public var motionTarget:MotionTarget;
		public var time:Number
		public var tweenType:*="linear"
		protected var activated:Boolean=true
		public function MotionTargetedGMC() {
			addEventListener(GameEvent.ADDED,onAdded);
		}
		private function onAdded(e:GameEvent):void {
			if (findMotionTarget()) {
				hasTarget=true;
				if(activated){
					startMotion(motionTarget);
				}
			} else {
				hasTarget=false;
			}
		}
		public function activate():void{
			if(hasTarget){
				startMotion(motionTarget)
			}
		}
		private function startMotion(m:MotionTarget):void {
			velocityX=3
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