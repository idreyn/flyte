package org.flyte.display{
	import flash.display.*;
	import flash.events.*;
	
	import mx.flash.UIMovieClip;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	/**
	 * The BackgroundObject class is really just a GameMovieClip that floats around in the background of a ScrollWorld, like a cloud
	 * or some mountains or something. The effect is called parallax scrolling, and it's used in most scrolling games.
	 * If you've added a BackgroundObject to your ScrollWorld and want to quickly specify its level, just tack it onto the end of its instance name!
	 * @author Ian Reynolds
	 * 
	 */
	public class BackgroundObject extends GameMovieClip {
		private var _level:uint;
		private var _originX:Number;
		private var _originY:Number;
		/**
		 * Whether the object should adjust its x position. 
		 */
		public var moveX:Boolean=true;
		/**
		 * Whether the object should adjust its y position. 
		 */
		public var moveY:Boolean=true;
		/**
		 * Constructor! 
		 * @param t The level to put the BackgroundObject on. A higher number means the object will appear farther away. If you don't specify this, the constructor will look for a number at the end of the instance name of the object, like clouds28 or buildings2
		 * 
		 */		
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

			if(moveX) this.x=_originX+((world.x)/_level)*4;
			if(moveY) this.y=_originY+((world.y)/_level)*4;
		}
		/**
		 * Sets the "level" of the BackgroundObject. The level indicates how far away it will appear, in other words how much it will
		 * compensate for movement of the ScrollWorld to appear onscreen. Check out the private enterFrame() event handler of this class to see how it works.
		 * @param i The level to set the object to, an unsigned int greater than 0.
		 * 
		 */		
		public function set level(i:uint):void {
			if (i>0) {
				_level=i;
			}
		}
		/**
		 * The level the object is on. 
		 * @return The level of the object.
		 * 
		 */		
		public function get level():uint
		{
			return _level
		}
	}
}