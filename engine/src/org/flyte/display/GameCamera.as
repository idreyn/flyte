package org.flyte.display{
	import flash.utils.Timer;
	
	import org.flyte.base.GameMovieClip;
	import org.flyte.events.GameEvent;
	import org.flyte.world.ScrollWorld;
	public class GameCamera extends GameMovieClip {
		/**
		 * A static property indicating the relative x position of the camera's target to the stage. 
		 */		
		public static var CAMERA_OFFSET_X:Number=200;
		/**
		 * A static property indicating the relative y position of the camera's target to the stage. 
		 */		
		public static var CAMERA_OFFSET_Y:Number=200;
		private var _target:GameMovieClip;
		private var _waitTimer:Timer;
		private var _tweenWait:uint
		private var _tweenYoyo:Boolean
		private var _tweenWorld:ScrollWorld
		private var _tweenType:Function
		private var _tx:Number
		private var _ty:Number
		private var _ts:uint
		private var active:Boolean=false;
		/**
		 * The degree of accuracy with which the camera will follow its target on the x axis. Lower values result in smoother camera movement. 
		 */		
		public var easeX:Number=0.2;
		/**
		 * The degree of accuracy with which the camera will follow its target on the y axis. Lower values result in smoother camera movement. 
		 */		
		public var easeY:Number=0.2;
		/**
		 * The value to which the GameCamera will set the scaleX and scaleY properties of its world, sort of like zooming in and out. 
		 * Be warned that too low a value will stop collisions from occuring properly, while a large value will slow things down. 
		 */		
		public var distance:Number=1
		public function GameCamera() {
			addEventListener(GameEvent.ADDED,onAdded)
		}
		
		private function onAdded(e:GameEvent):void
		{
			addLoopListener(onLoop)
		}
		public function follow(g:GameMovieClip):void {
			_target=g;
		}
		/**
		 * Sets the object in the GameCamera's world that it will follow.
		 * @param g The object to follow
		 * 
		 */
		public function set target(g:GameMovieClip):void {
			_target=g;
		}
		/**
		 * Gives the object in the GameCamera's world that it is following.
		 * @return The GameCamera's target
		 * 
		 */
		public function get target():GameMovieClip {
			return _target;
		}
						  
		private function onLoop(e:GameEvent):void {
			try {
				if (! active) {
					world.x-=((_target.x+(world.x/distance)-CAMERA_OFFSET_X)*easeX)
					world.y-=((_target.y+(world.y/distance)-CAMERA_OFFSET_Y)*easeY)
					world.scaleX=world.scaleY=distance
				}
			} catch (e:ReferenceError) {
				trace("GameCamera has not been added to stage");
			}
		}
	}
}