package flyte.display{
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import flyte.base.*;
	import flyte.events.*;
	import flyte.projectile.*;
	import flyte.utils.*;
	import flyte.world.*;
	public class ActionManager extends EventDispatcher {
		public var a:Dictionary;
		public var frameLabels:Array;
		public var DEFAULT:String;
		public var active:Boolean=false;
		public var g:GameMovieClip;
		private var currentAction:Action;
		private var currentActionFrame:String;
		private var currentActionMovie:MovieClip;
		public function ActionManager(e:GameMovieClip) {
			a=new Dictionary();
			g=e;
			frameLabels=getLabels();
			g.addEventListener(GameEvent.ADDED,onAdded);
		}
		private function getLabels():Array {
			var a:Array=new Array();
			for (var i=0; i<g.currentLabels.length; i++) {
				a.push(g.currentLabels[i].name);
			}
			return a;
		}
		private function onAdded(e:GameEvent):void {
			if (getLabels().length>1) {
				Game._root.addEventListener(GameEvent.LOOP,loop);
			}
		}
		public function setDefault(s:String):void{
			DEFAULT=s
		}
		public function mapAction(name:String,frame:*,action:Function,loops:Boolean=false,resetOnComplete:Boolean=true):void {
			if (frame is Array) {
				var t:Boolean=true;
				var has:Array=new Array();
				for (var i=0; i<frame.length; i++) {
					g.gotoAndStop(frame[i]);
					has[i]=g.getChildByName(frame[i])!=null;
					if (frameLabels.indexOf(frame[i])<0) {
						t=false;
						throw new Error("Flyte Error: attempt to map an action to a frame of GameMovieClip "+g.name+" called "+frame+" that does not exist");
					}

				}
				if (t) {
					a[name]=new Action(name,frame,action,has,loops,resetOnComplete);
				}
			} else {
				var has2=new Boolean();
				g.gotoAndStop(frame);
				if (frameLabels.indexOf(frame)>-1) {
					has2=g.getChildByName(frame)!=null;
					a[name]=new Action(name,frame,action,has2,loops,resetOnComplete);
				}

			}
		}
		public function resetKeys():void
		{
			for each(var value:Action in a)
			{
				value.active=false;
			}
		}
		public function actionInProgress(b:String):Boolean {
			return a[b].active;
		}
		public function setAction(b:String):void {
			if (hasAction(b)) {
				if (a[b].hasAnimation) {
					if (! a[b].loop) {
						active=true;
					}
					a[b].active=true;
					var f:String;
					if (a[b].frame is Array) {
						f=RandomUtil.randomIndex(a[b].frame);
					} else {
						f=a[b].frame;
					}
					g.gotoAndStop(f);
					currentActionMovie=g.getChildByName(f) as MovieClip;
					currentActionMovie.gotoAndPlay(1);
					currentAction=a[b];
					currentActionFrame=f;
				} else {
					a[b].actionOnComplete.call(g);
				}
			}
		}
		public function hasAction(b:String):Boolean {
			return a[b] != null;
		}
		public function reset():void {
			setAction(DEFAULT);
		}
		public function set action(s:String):void{
			setAction(s)
		}
		public function loop(e:GameEvent):void {
			if (active) {
				if (currentActionMovie.currentFrame>=currentActionMovie.totalFrames||! g.contains(g.getChildByName(currentActionFrame))) {
					currentAction.active=false;
					active=false;
					dispatchEvent(new GameEvent(GameEvent.ACTION_COMPLETE,{action:currentAction.name}));
					currentAction.actionOnComplete.call(g);
					if (currentAction.resetOnComplete) {
						currentAction.active=false
						reset();
					} else {
						if (currentAction.loops) {
							currentActionMovie.gotoAndPlay(1);
						} else {
							currentActionMovie.stop();
						}
					}
				}
			}
		}
		protected function nothing():void {
		}




	}
}