package org.flyte.display{
	import flash.utils.Timer;
	
	import org.flyte.base.GameMovieClip;
	import org.flyte.events.GameEvent;
	import org.flyte.world.ScrollWorld;
	public class GameCamera extends GameMovieClip {
		public static var CAMERA_OFFSET_X:Number=200;
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
		public var easeX:Number=0.2;
		public var easeY:Number=0.2;
		public var distance:Number=1
		public function GameCamera() {
			addLoopListener(onLoop)
		}
		public function follow(g:GameMovieClip):void {
			_target=g;
		}
		public function set target(g:GameMovieClip):void {
			_target=g;
		}
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