package org.flyte.display{
	import flash.display.*;
	import flash.events.*;
	import org.flyte.base.*;
	import org.flyte.events.*;
	public class BackgroundObject extends MovieClip {
		private var _level:uint;
		private var _originX:Number;
		private var _originY:Number;
		public var moveX:Boolean=true;
		public var moveY:Boolean=true;
		public function BackgroundObject(t:uint=0) {
			var r:RegExp=/[A-Za-z]*([0-9]*)/;
			if (t==0) {
				var l:uint=uint(r.exec(this.name)[1]);
				if (l==0) {
					throw new Error("Flyte Error: A BackgroundObject cannot exist on level 0. Please change the instance name of "+this.name+" and make sure it ends in an integer denoting its level");
				} else {
					level=l;
				}
			} else {
				level=t;
			}
			_originX=this.x;
			_originY=this.y;
			addEventListener(Event.ADDED,onAdded);
			addEventListener(Event.ENTER_FRAME,enterFrame);
		}
		private function onAdded(e:Event):void {

		}
		private function enterFrame(e:Event):void {

			this.x=_originX+((Game._root.world.x)/_level)*4;
			this.y=_originY+((Game._root.world.y)/_level)*4;
		}
		public function set level(i:uint):void {
			if (i>0) {
				_level=i;
			}
		}
	}
}