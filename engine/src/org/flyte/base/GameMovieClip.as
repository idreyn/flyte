
﻿package org.flyte.base{
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.GameEvent;
	import org.flyte.motion.*;
	import org.flyte.world.ScrollWorld;
	/**
	 * A GameMovieClip represents anything within your game that reacts to events in the game, has a Sensors object
	 * surrounding it for collisions.
	 * and makes use of ActionManager to control its timeline. Just about anything you add to your
	 * game should be a GameMovieClip.
	 * @author Ian Reynolds
	 * @see org.flyte.display.ActionManager
	 */
	public class GameMovieClip extends MovieClip {
		private var t:Timer;
		private var removeList:Array;
		/**
		 * The ScrollWorld that (Flyte thinks) contains the GameMovieClip. IMPORTANT! This property cannot
		 * be accessed until the GameMovieClip has received it, at which time it will dispatch GameEvent.ADDED.
		 * To get the current ScrollWorld, use Game._root.world. But that's playing with fire.
		 * @see org.flyte.world.ScrollWorld
		 * @see org.flyte.base.Game
		 */
		public var world:ScrollWorld;
		/**
		 * The velocity of the GameMovieClip on the x-axis. Depending on the direction of movement, this
		 * may be positive or negative. This property is explicitly set to change the speed of an object.
		 */
		public var velocityX:Number=0;
		/**
		 * The velocity of the GameMovieClip on the y-axis. This is usually positive and is explicitly set
		 * only to simulate gravity.
		 */
		public var velocityY:Number=0;
	//	public var motion:MotionManager
		protected var originX:Number;
		protected var originY:Number;
		/**
		 * The action object is an instance of ActionManager that allows for different actions (running, attacking, etc.)
		 * to be "mapped" to frame labels and instance names of animations within the GameMovieClip's symbol in Flash.
		 * You might call <listing version="3.0">action.setAction(Action.RUN)</listing> to cause the object to send its
		 * timeline to the frame associated with <listing version="3.0">Action.RUN</listing> by <listing version="3.0">action.mapAction()</listing>
		 * The action object has a property called DEFAULT (referring to the default state of the GameMovieClip), which is not to be confused with <listing version="3.0">Action.DEFAULT</listing>
		 * which, if it existed, would be a static property of the Action class rather than an instance property of ActionManager.
		 * @see org.flyte.display.ActionManager#setAction()
		 * @see org.flyte.display.ActionManager#mapAction()
		 * @see org.flyte.display.Action
		 * */
		public var action:ActionManager;
		protected var ignored:Boolean=false;
		/**
		 * Whether the GameMovieClip resets various properties when the ScrollWorld resets.
		 * Subclasses of GameMovieClip generally make use of this property.
		 */
		public var resettable:Boolean=true;
		private var loopQueue:Array
		private var resetQueue:Array
		
		/**
		 * @param s If you want to set the world property right now (if the GameMovieClip has been created 
		 * after the ScrollWorld initializes, rather than part of the world's symbol, go for it!
		 * @see org.flyte.world.ScrollWorld
		 */
		public function GameMovieClip(s:ScrollWorld=null) {
			this.world=s
			loopQueue=new Array()
			resetQueue=new Array()
			t=new Timer(10);
			t.addEventListener(TimerEvent.TIMER,onTimer);
			t.start();
			originX=this.x;
			originY=this.y;
			action=new ActionManager(this);
			//motion = new MotionManager(this)
			mapActions();
			removeList=new Array();

		}
		
		/**
		 *Returns a list of all GameMovieClips in the current world. I still can't think of a reason to use this. 
		 * @return All GameMovieClips in the current world!
		 */
		public static function get enum():Array
		{
			return Game._root.world.gmcEnum
		}
		/**
		 * Adds an event listener for GameEvent.LOOP that calls the function f.
		 * The same as calling
		 * <listing version="3.0">world.addEventListener(GameEvent.LOOP,f)</listing>
		 * The nice thing about this method is that even if the GameMovieClip does not have its world property,
		 * the event listener will be created when it does. So you can use this inside a contructor!
		 * @see org.flyte.events.GameEvent
		 */
		public function addLoopListener(f:Function):void {
			if(world == null){
				loopQueue.push(f)
			}else{
				world.addEventListener(GameEvent.LOOP,f);
			}
		}
		/**
		 * Adds an event listener for GameEvent.RESET_LEVEL that calls the function f.
		 * The same as calling
		 * <listing version="3.0">world.addEventListener(GameEvent.RESET_LEVEL,f)</listing>
		 * Like addLoopListener(), feel free to use inside of a constructor.
		 * @see org.flyte.events.GameEvent
		 */
		public function addResetListener(f:Function):void {
			if(world==null)
			{
				this.resetQueue.push(f)
			}else{
				world.addEventListener(GameEvent.RESET_LEVEL,f);
			}
		}
		
		/**
		 * Checks if the GameMovieClip collides with something else.
		 * @param d The DisplayObject to test against
		 * @return 
		 * 
		 */
		public function collides(d:DisplayObject):Boolean
		{
			return Collision.hitTestShape(this,d);
		}
		protected function mapActions():void {

		}
	
		/**
		 * Another little shortcut. Identical to:
		 * <code>dispatchEvent(new GameEvent(e,p)) 
		 * @param e The name of the GameEvent to dispatch
		 * @param p Any parameters you might want to include
		 * 
		 */
		public function dispatchGameEvent(e:String,p:Object=null):void
		{
			dispatchEvent(new GameEvent(e,p));
		}
		private function checkOnstage(e:GameEvent):void {
			if (! onStage&&Game.IGNORE_OUTSIDE) {
				if (! ignored) {
					ignored=true;
					stopListening();
				}
			} else {
				if (ignored) {
					ignored=false;
					startListening();
				}
			}
		}
		/**
		 * A call to removeMe() tells the GameMovieClip to remove GameMovieClip d if it is a child
		 * of the called GameMovieClip. For instance, a Projectile calls it this way
		 * <listing version="3.0">container.removeMe(this)</listing>
		 * (A Projectile has a property called Container, which is simply its parent on the display
		 * list cast as a GameMovieClip. Its parent, the ProjectileEmitter, then removes it on the next
		 * GameEvent.LOOP iteration.
		 * @see org.flyte.events.GameEvent#LOOP
		 * @see org.flyte.projectile.Projectile
		 * @see org.flyte.projectile.ProjectileEmitter
		 */
		public function removeMe(d:GameMovieClip):void {
			removeList.push(d);
		}
		private function get onStage():Boolean {
			return Collision.hitTestShape(this,Game._root.stageTest);
		}
		private function onTimer(e:TimerEvent):void {
			t.stop();
			this.world=Game._root.world
			GameMovieClip.enum.push(this)
			addEventListener(GameEvent.ADDED,onAdded);
			this.dispatchEvent(new GameEvent(GameEvent.ADDED));
			
			addQueue();
			if (! this is ScrollWorld) {
				world.addEventListener(GameEvent.LOOP,checkOnstage);
			}
			world.addEventListener(GameEvent.LOOP,removeChildren);
			world.addEventListener(GameEvent.LOOP,onLoop);
			world.addEventListener(GameEvent.RESET_LEVEL,onResetLevel);
		}
		

		
		private function addQueue():void
		{
			for(var i:uint=0;i<loopQueue.length;i++){
				addLoopListener(loopQueue[i])
			}
			for(i=0;i<resetQueue.length;i++){
				addResetListener(resetQueue[i])
			}
		}
		private function onLoop(e:GameEvent):void {
		}
		protected function stopListening():void {
			//Game._root.removeEventListener(GameEvent.LOOP,onLoop);
			this.visible=false;
		}
		private function onAdded(e:GameEvent):void {
		}
		protected function startListening():void {
			world.addEventListener(GameEvent.LOOP,onLoop);
			this.visible=true;
		}
		private function onResetLevel(e:GameEvent):void {
				action.unlock();
				action.resetKeys();
				this.x=originX;
				this.y=originY;
				this.velocityY=0;
				customReset();
				startListening();
				action.setAction(action.DEFAULT)
				dispatchEvent(new GameEvent(GameEvent.RESET_COMPLETE,{from:"GameMovieClip"}))
		}
		
		/**
		 * The point where the GameMovieClip started in the ScrollWorld. 
		 * @return The point of origin
		 * 
		 */
		public function get origin():Point
		{
			return new Point(this.originX,this.originY)
		}
		
		/**
		 * The GameMovieClip's position, as a Point object. 
		 * @return The object's position
		 * 
		 */
		public function get position():Point
		{
			return new Point(this.x,this.y)
		}
		
		protected function customReset():void {

		}
		protected function nothing():void {
		}

		private function removeChildren(e:GameEvent):void {
			if (removeList.length==0) {
			}
			return void;
			for(var i:uint=0; i<removeList.length; i++) {
				removeChild(removeList[i]);
				delete removeList[i];
			}
			removeList=new Array();
		}
		public function killChild(m:MovieClip):void{
			removeChild(m);
			m=null;
		}
		protected function degrees(r:Number):Number {
			return r*(180/Math.PI);
		}
		protected function radians(d:Number):Number {
			return d*(Math.PI/180);
		}
	}
}