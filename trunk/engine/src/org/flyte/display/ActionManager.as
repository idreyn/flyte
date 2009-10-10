package org.flyte.display{
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.projectile.*;
	import org.flyte.utils.*;
	import org.flyte.world.*;
	/**
	 * An ActionManager is an object (generally a property of a GameMovieClip) that defines which of its frames it is on at any given time.
	 * Since any GameMovieClip is expected to have multiple states, and these are often set concurrently, the ActionManager makes sure that these don't get mixed up.
	 * Using the ActionManager requires these steps:
	 * 1. Mapping Actions to frames. This uses the mapAction() method.
	 * 2. Naming the frames inside Flash with the info given to the ActionManager.
	 * 3. Banging head on keyboard with mind-numbing boringness.
	 * 
	 * For instance, let's imagine that you have two states for a GameMovieClip inside of its timeline in Flash.
	 * One is standing still, the other is running. To use ActionManager, you would:
	 * 1. Have two frames called "still" and "run"
	 * 2. Have a Movieclip inside each frame called "still" and "run" that contains the animation.
	 * 3. Map the actions to the frames inside of the GameMovieClip's class with this code:
	 * <listing version="3.0">
	 * action.mapAction(Action.STILL,"still",nothing)
	 * action.mapAction(Action.RUN,"run",onRunFinish)
	 * </listing>
	 * 4. To make the GameMovieClip do its running animation, you could then call:
	 * <listing version="3.0">action.setAction(Action.RUN)</listing>
	 * When the animation inside of the "run" Movieclip on the frame "run" reaches the end of the timeline, the ActionManager will call its parent's function called onRunComplete.
	 * Note that the name of the frame/movieclip and the Action is arbitrary. You could easily do something ridiculous like this:
	 * <listing version="3.0">action.mapAction("bazookaJoe","funkyChicken",nothing)</listing>
	 * Then, to make the GameMovieClip show the frame called "funkyChicken", you would call
	 * <listing version="3.0">action.setAction("bazookaJoe")</listing>
	 * Yes, it's a little confusing, but it's very versatile once you get the hang of it.
	 * @see org.flyte.display.Action
	 * @see org.flyte.display.ActionManager#setAction
	 * @see org.flyte.display.ActionManager#mapAction
	 * @see org.flyte.base.GameMovieClip#action
	 * @author Ian Reynolds
	 * 
	 */
	public class ActionManager extends EventDispatcher {
		/**
		 * A Dictionary object holding all the actions. Don't touch this.
		 */
		public var a:Dictionary;
		/**
		 * A list of all the frame labels that the ActionManager's parent holds.
		 */
		public var frameLabels:Array;
		/**
		 * The default action to be called when an action finishes. You should set this after you map your actions.
		 */
		public var DEFAULT:String;
		/**
		 * Whether the ActionManager is looping an action or just idling on Action.DEFAULT.
		 */
		public var active:Boolean=false;
		/**
		 * The target (usually the parent) of the ActionManager. Not a very good name, but you shouldn't be digging around in here anyway.
		 */
		public var g:GameMovieClip;
		private var currentAction:Action;
		private var currentActionFrame:String;
		private var currentActionMovie:MovieClip;
		/**
		 * The ActionManager constructor
		 * @param e The GameMovieClip that the ActionManager controls. For our sanity, let's just make it the parent of the ActionManager, although in theory it could be external.
		 */
		public function ActionManager(e:GameMovieClip) {
			a=new Dictionary();
			g=e;
			frameLabels=getLabels();
			g.addEventListener(GameEvent.ADDED,onAdded);
		}
		private function getLabels():Array {
			var a:Array=new Array();
			for(var i:uint=0; i<g.currentLabels.length; i++) {
				a.push(g.currentLabels[i].name);
			}
			return a;
		}
		private function onAdded(e:GameEvent):void {
			if (getLabels().length>1) {
				Game._root.addEventListener(GameEvent.LOOP,loop);
			}
		}
		/**
		 * Sets the DEFAULT property. Yep.
		 * @param s The action that the ActionManager should call when it's not doing anything else, i.e. Action.STILL or maybe "idle". Go crazy.
		 */
		public function setDefault(s:String):void{
			DEFAULT=s
		}
		
		/**
		 * Maps an action to a frame inside of a GameMovieClip. See the class detail for instruction on doing this. 
		 * @param name The name of the action. Used by setAction() to call an action.
		 * @param frame A string that is both the name of the frame called and the Movieclip inside it. This can also be an array; if that is the case, each time the mapped action is called, the ActionManager will choose a random frame from the array.
		 * @param func A function that will be called by the ActionManager when the action finishes. If you don't want anything to happen, just specify "nothing", like so: <listing version="3.0">action.mapAction(Action.JUMP,"jump",nothing)</listing> and the ActionManager will actually call a conveniently placed method in the GameMovieClip called nothing, which, you guessed it, does nothing.
		 * @param loops Whether the ActionManager will keep looping this action until another one is called.
		 * @param resetOnComplete Whether the ActionManager will set its action to its DEFAULT property when this action completes. If loops is false and this is true, it will just hang there at the last frame of the animation.
		 * @see org.flyte.base.GameMovieClip#setAction
		 * @see #setDefault
		 */
		public function mapAction(name:String,frame:*,func:Function,loops:Boolean=false,resetOnComplete:Boolean=true):void {
			if (frame is Array) {
				var t:Boolean=true;
				var has:Array=new Array();
				for (var i:uint=0; i<frame.length; i++) {
					g.gotoAndStop(frame[i]);
					has[i]=g.getChildByName(frame[i])!=null;
					if (frameLabels.indexOf(frame[i])<0) {
						t=false;
						throw new Error("Flyte Error: attempt to map an func to a frame of GameMovieClip "+g.name+" called "+frame+" that does not exist");
					}

				}
				if (t) {
					a[name]=new Action(name,frame,func,has,loops,resetOnComplete);
				}
			} else {
				var has2:Boolean=new Boolean();
				g.gotoAndStop(frame);
				if (frameLabels.indexOf(frame)>-1) {
					has2=g.getChildByName(frame)!=null;
					a[name]=new Action(name,frame,func,has2,loops,resetOnComplete);
				}

			}
		}
		/**
		 * Sets the active property of all mapped actions to false. Useful so GameMovieClips don't get caught in limbo when a ScrollWorld resets.
		 * @see org.flyte.world.ScrollWorld
		 */
		public function resetKeys():void
		{
			for each(var value:Action in a)
			{
				value.active=false;
			}
		}
	
		/**
		 * Returns whether the specified Action is the one currently being played.
		 * @param action The Action to check
		 * @return Whether or not the Action is happening now.
		 * 
		 */
		public function actionInProgress(action:String):Boolean {
			return a[action].active;
		}
		/**
		 * Sets the current frame to the one mapped to the string b.
		 * @param b The string representing an action to play
		 * @see #mapAction
		 */
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
		
		/**
		 * Returns whether the ActionManager has an action for the specified string (in other words, whether calling action.setAction(b) would do anything)
		 * @param b The string to check
		 * @return Whether or not the action has been mapped.
		 * 
		 */
		public function hasAction(b:String):Boolean {
			return a[b] != null;
		}
		/**
		 * Sets the action to this ActionManager's DEFAULT property.
		 */
		public function reset():void {
			setAction(DEFAULT);
		}
	
		/**
		 * Same as calling setAction() 
		 * @param s The action to call.
		 * 
		 */
		public function set action(s:String):void{
			setAction(s)
		}
		/**
		 * Called whenever the ActionManager hears a GameEvent.LOOP event.
		 */
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