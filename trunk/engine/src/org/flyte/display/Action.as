package org.flyte.display{
	/**
	 * An Action is an object that describes a state that a GameMovieClip can have.
	 * Each GameMovieClip has an ActionManager property that controls which of its 
	 * multiple frames in the Flash timeline is currently playing. To make use of this
	 * system, it's necessary (and painful) to create a frame for each Action a character
	 * can perform, and then place a Movieclip with the actual animation inside it on that
	 * frame. The MovieClip's instance name and the frame's label should be the same, and 
	 * should match the frame parameter given to the ActionManager's mapAction() function.
	 * For instance, if inside of a GameObject you had this:
	 * <listing version="3.0">action.mapAction(Action.JUMP,"jump",onJumpComplete)</listing>
	 * then you would name a frame inside of the GameObject "jump" and place a MovieClip named
	 * "jump" on that frame which contains the animation. When the animation is complete, the
	 * GameObject reverts to its normal state (its DEFAULT property), and the function onJumpComplete is called.
	 * It gets confusing but it is important to remember two things:
	 * 1. The ActionManager inside each GameMovieClip is called "action" with a lowercase A, different than the actual class called Action.
	 * 2. The value of Action.STILL, Action.RUN etc. is irrelevant; you can call your running animation "snorkel" so long as you map it that way.
	 * @see org.flyte.base.GameObject
	 * @see org.flyte.base.GameMovieClip#action
	 * @see org.flyte.display.ActionManager#mapAction
	 * @author Ian Reynolds
	 * 
	 */
	public dynamic class Action{
		public static const STILL:String="actionStill"
		public static const RUN:String="actionRun"
		public static const ATTACK:String="actionAttack"
		public static const HIT:String="actionHit"
		public static const DIE:String="actionDie"
		public static const JUMP:String="actionJump"
		public static const CLIMB:String="actionClimb"
		public static const THROW:String="actionThrow"
		public static const FLIP:String="actionFlip"
		public static const CHANGE_DIRECTION:String="actionChangeDirection"
		public static const DESTROY:String="actionDestroy"
		public static const DEACTIVATE:String="actionDeactivate"
		public static const ACTIVATE:String="actionActivate"
		public static const NORMAL:String="actionNormal"
		/**
		 * A boolean value determining whether the action will loop until its parent calls action.setAction() again.
		 */
		public var loops:Boolean
		/**
		 * A string or an array of strings referring to the frame that will be played when this action is called. If it
		 * is an array, then the ActionManager will call a random frame.
		 * @see org.flyte.display.ActionManager
		 */
		public var frame:*
		/**
		 * A string denoting the action that this Action instance refers to. For example,
		 * Action.RUN should be used to refer to running. Of course, you're free to make up your own.
		 */
		public var name:String
		/**
		 * Whether the current action is active. Since you can't directly access any Action instances outside of
		 * an ActionManager, it's safe to ignore this one.
		 */
		public var active:Boolean
		/**
		 * Whether the ActionManager will cause its target to reset when this Action finishes
		 */
		public var resetOnComplete:Boolean
		/**
		 * The function called by the ActionManager when the Action completes.
		 * It really should be called "functionOnComplete", I'll get someone on that... *cough*
		 * But again, it really doesn't matter what it's called since you will never have to interact with it directly.
		 */
		public var actionOnComplete:Function
		/**
		 * To be honest, I'm not sure whether this one is still necessary, but let's not tempt fate here.
		 */
		public var hasAnimation:*
		public function Action(name:String,frame:*,action:Function,hasAnimation:*,loops:Boolean=false,resetOnComplete:Boolean=true){
			this.name=name
			this.frame=frame
			this.loops=loops
			this.resetOnComplete=resetOnComplete
			this.actionOnComplete=action
			this.hasAnimation=hasAnimation
		}
		public function start():void{
			active=true
		}
		public function stop():void{
			active=false
		}
	}
}