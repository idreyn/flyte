
﻿package org.flyte.base{
	import flash.display.*;
	import flash.events.TimerEvent;
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
		 * A static array of all the GameMovieClips in the flash file.
		 */
		public static var enum:Array=new Array();
		/**
		 * The current ScrollWorld loaded by the current Game (Game._root). This is not
		 * a property unique to each GameMovieClip but rather is set by a call to GameMovieClip.updateRoot().
		 * @see #updateRoot()
		 * @see #myWorld
		 * @see org.flyte.world.ScrollWorld
		 */
		public var world:ScrollWorld;
		/**
		 * A refernce to the ScrollWorld that contains the GameMovieClip.
		 * @see org.flyte.world.ScrollWorld
		 */
		public var myWorld:ScrollWorld;
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
		public function GameMovieClip() {
			enum.push(this);
			t=new Timer(10);
			t.addEventListener(TimerEvent.TIMER,onTimer);
			t.start();
			originX=this.x;
			originY=this.y;
			action=new ActionManager(this);
			mapActions();
			removeList=new Array();

		}
		/**
		 * Adds an event listener for GameEvent.LOOP that calls the function f.
		 * The same as calling
		 * <listing version="3.0">Game._root.addEventListener(GameEvent.LOOP,f)</listing>
		 * @see org.flyte.events.GameEvent
		 */
		public function addLoopListener(f:Function):void {
			Game._root.addEventListener(GameEvent.LOOP,f);
		}
		/**
		 * Adds an event listener for GameEvent.RESET_LEVEL that calls the function f.
		 * The same as calling
		 * <listing version="3.0">Game._root.world.addEventListener(GameEvent.RESET_LEVEL,f)</listing>
		 * @see org.flyte.events.GameEvent
		 */
		public function addResetListener(f:Function):void {
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,f);
		}
		
		public function collides(d:DisplayObject):Boolean
		{
			return Collision.hitTestShape(this,d);
		}
		protected function mapActions():void {

		}
		/**
		 * Updates the world property of all GameMovieClips to the specified ScrollWorld.
		 * Use with caution. Or rather, not at all.
		 * @param w The ScrollWorld that all GameMovieClips will refer to as world.
		 * @see GameMovieClip#world
		 * @see org.flyte.world.ScrollWorld.
		 */
		public static function updateRoot(w:ScrollWorld):void {
			for(var i:uint=0; i<enum.length; i++) {
				enum[i].world=w;
			}
		}
		
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
			this.dispatchEvent(new GameEvent(GameEvent.ADDED));
			addEventListener(GameEvent.ADDED,onAdded);
			if (! this is ScrollWorld) {
				Game._root.addEventListener(GameEvent.LOOP,checkOnstage);
			}
			Game._root.addEventListener(GameEvent.LOOP,removeChildren);
			Game._root.addEventListener(GameEvent.LOOP,onLoop);
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,onResetLevel);
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
			Game._root.addEventListener(GameEvent.LOOP,onLoop);
			this.visible=true;
		}
		private function onResetLevel(e:GameEvent):void {
				action.resetKeys();
				this.x=originX;
				this.y=originY;
				this.velocityY=0;
				customReset();
				startListening();
				action.setAction(action.DEFAULT)
			
			
		}
		protected function customReset():void {

		}
		protected function nothing():void {
		}
		/**
		 * Returns the direction to the point (x,y) from the called GameMovieClip in degrees.
		 * I'm not sure why Actionscript doesn't have such a method built in.
		 * @param x The x-value of the desired point
		 * @param y The y-value of the desired point
		 * @return The rotation the GameMovieClip would have if pointing towards (x,y)
		 */
		public function getDegreesToPoint(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			return degrees(Math.atan2(y1-y2,x1-x2));
		}

		public function r2p(ax:Number,ay:Number,x:Number,y:Number):Number {
			var dx:Number=x-ax
			var dy:Number=y-dy
			var quad:Number;
			if (dx>0&&dy>0) {
				quad=4;
			}
			if (dx<0&&dy>0) {
				quad=1;
			}
			if (dx<0&&dy<0) {
				quad=2;
			}
			if (dx>0&&dy<0) {
				quad=3;
			}
			var ax:Number=Math.abs(dx);
			var ay:Number=Math.abs(dy);
			var theta:Number=Math.atan(ay/ax)*(180/Math.PI);
			var angle:Number;
			if (quad==1) {
				angle=90-theta;
			}
			if (quad==2) {
				angle=90+theta;
			}
			if (quad==3) {
				angle=270-theta;
			}
			if (quad==4) {
				angle=270+theta;
			}
			return angle;
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