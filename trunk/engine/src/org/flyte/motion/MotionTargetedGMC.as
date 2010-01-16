package org.flyte.motion{
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.display.DisplayObject;
	import flash.events.*;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	
	public class MotionTargetedGMC extends GameMovieClip implements IMotionTargetable{
		public var hasTarget:Boolean=false;
		public var usesTarget:Boolean=false;
		public var motionTarget:MotionTarget;
		public var time:Number
		private var tweenX:Tween
		private var tweenY:Tween
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
			if(!time>0) time=Math.sqrt(Math.pow(m.x-this.x,2)+Math.pow(m.y-this.y,2))/velocityX;
			tweenX=new Tween(this,"x",None.easeNone,this.x,m.x,time,false);
			tweenY=new Tween(this,"y",None.easeNone,this.y,m.y,time,false);
			tweenX.addEventListener(TweenEvent.MOTION_FINISH,tweenComplete);
		}
		private function tweenComplete(e:Event):void {
			tweenX.yoyo();
			tweenY.yoyo();
		}
		protected function stopMotion():void
		{
			tweenX.stop();
			tweenY.stop();
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