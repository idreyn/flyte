package org.flyte.motion{
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	public class MotionTargeted extends GameMovieClip implements IMotionTargetable{
		public var hasTarget:Boolean=false;
		public var usesTarget:Boolean=false;
		public var motionTarget:MotionTarget;
		private var tweenX:Tween
		private var tweenY:Tween
		public function MotionTargeted() {
			addEventListener(GameEvent.ADDED,onAdded);
		}
		private function onAdded(e:GameEvent):void {
			if (findMotionTarget()) {
				hasTarget=true;
				startMotion(motionTarget);
			} else {
				hasTarget=false;
			}
		}
		private function startMotion(m:MotionTarget):void {
			velocityX=3
			var time:Number=Math.sqrt(Math.pow(m.x-this.x,2)+Math.pow(m.y-this.y,2))/velocityX;
			tweenX=new Tween(this,"x",None.easeNone,this.x,m.x,time,false);
			tweenY=new Tween(this,"y",None.easeNone,this.y,m.y,time,false);
			tweenX.addEventListener(TweenEvent.MOTION_FINISH,tweenComplete);
		}
		private function tweenComplete(e:TweenEvent):void {
			tweenX.yoyo();
			tweenY.yoyo();
		}
		public function findMotionTarget():Boolean {
			var n:String=this.name;
			var c:Boolean=true;
			var has:Boolean=false;
			for(var i:uint=0; i<MotionTarget.enum.length; i++) {
				var t:*=MotionTarget.enum[i]
				var tn:String=t.name;
				if (tn.slice(0,n.length)==n&&t!=this&&t is MotionTarget) {
					motionTarget=t;
					motionTarget.visible=false;
					has=true;
					break;
				}
			}
			return has;
		}

	}
}