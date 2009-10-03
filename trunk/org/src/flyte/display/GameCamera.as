﻿package flyte.display{
	import flyte.events.GameEvent;
	import flyte.base.Game;
	import flyte.base.GameMovieClip;
	import flyte.world.ScrollWorld
	import flash.utils.Timer
	import flash.events.TimerEvent
	public class GameCamera extends GameMovieClip {
		public static var CAMERA_OFFSET_X=200;
		public static var CAMERA_OFFSET_Y=200;
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
					world.x=0-_target.x+CAMERA_OFFSET_X;
					world.y=0-_target.y+CAMERA_OFFSET_Y;
				}
			} catch (e:ReferenceError) {
				trace("GameCamera has not been added to stage");
			}
		}
	}
}