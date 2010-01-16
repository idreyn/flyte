package org.flyte.collision{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.flyte.base.GameMovieClip;
	
	/**
	 * A Sensors object a sort of "wrapper" for a GameObject that helps it detect collisions.
	 * It basically consists of a number of sprites surrounding the GameObject. For instance,
	 * a game element could check to see if it is colliding with the right side of the current Character like this:
	 * <listing version="3.0">Collision.hitTestShape(this,Character.current.sensors.right)</listing>
	 * @author Ian Reynolds
	 * @see org.flyte.collision.Collision#hitTestShape
	 * @see org.flyte.character.Character#current
	 */
	public class Sensors extends GameMovieClip {
		private var thickness:uint;
		private var target:GameMovieClip;
		/**
		 * A sprite located at the bottom of the Sensors, on the left.
		 */
		public var bottomLeft:Sprite;
		/**
		 * A sprite located at the bottom of the Sensors, on the right.
		 */
		public var bottomRight:Sprite;
		/**
		 * A sprite located at the bottom of the Sensors, in the center.
		 */
		public var bottomMiddle:Sprite;
		/**
		 * A sprite covering the bottom edge of the Sensors.
		 */
		public var bottom:Sprite;
		/**
		 * A sprite covering the left edge of the Sensors.
		 */
		public var left:Sprite;
		/**
		 * A sprite covering the right edge of the Sensors.
		 */
		public var right:Sprite;
		/**
		 * A sprite covering the top edge of the Sensors.
		 */
		public var top:Sprite;
		/**
		 * A sprite located at the bottom right-hand corner of the Sensors that extends below the parent GameObject. Useful for finding ledges.
		 */
		public var rightEdge:Sprite;
		/**
		 * A sprite located at the bottom left-hand corner of the Sensors that extends below the parent GameObject. Uuseful for finding ledges.
		 */
		public var leftEdge:Sprite;
		private var maxInstability:Number=100;
		private var minInstability:Number=2;
		private var hits:Dictionary;
		private var r:Rectangle;
		/**
		 * 
		 * @param target The object that the Sensors should draw itself around, so usually its parent.
		 * @param thick How thick the actual sensors should be. 1 is the magic number.
		 * 
		 */
		public function Sensors(target:GameMovieClip,thick:uint=1) {
			hits=new Dictionary();
			this.target=target;
			this.thickness=thick/target.scaleY
			drawSensors();
			//this.alpha=0.0;
		}
		private function drawSensors():void {
			init();
			drawBoxes(this.target.getBounds(this.target));
			r=this.target.getBounds(this.target);
		}
		private function init():void {
			bottomLeft=new Sprite();
			bottomRight=new Sprite();
			bottomMiddle=new Sprite();
			bottom=new Sprite();
			left=new Sprite();
			right=new Sprite();
			top=new Sprite();
			rightEdge=new Sprite();
			leftEdge=new Sprite();
			bottomLeft.graphics.lineStyle(thickness,0xFF0000);
			bottomRight.graphics.lineStyle(thickness,0x00FF00);
			bottomMiddle.graphics.lineStyle(thickness,0xFF9900);
			bottom.graphics.lineStyle(thickness,0x0000FF);
			left.graphics.lineStyle(thickness,0x00FF00);
			right.graphics.lineStyle(thickness,0x0000FF);
			top.graphics.lineStyle(thickness,0x0000FF);
			leftEdge.graphics.lineStyle(thickness,0x0000FF);
			rightEdge.graphics.lineStyle(thickness,0x0000FF);
			addChild(bottom);
			addChild(bottomLeft);
			addChild(bottomRight);
			addChild(bottomMiddle);
			addChild(left);
			addChild(right);
			addChild(top);
			addChild(leftEdge);
			addChild(rightEdge)

		}
		private function drawBoxes(r:Rectangle):void {
			bottomLeft.graphics.drawRect(r.left+r.width/8,r.bottom,r.width/4,this.thickness);
			bottomRight.graphics.drawRect(r.left+r.width/2+r.width/8,r.bottom,r.width/4,this.thickness);
			bottomMiddle.graphics.drawRect(r.left+r.width/2-r.width/8,r.bottom,r.width/4,this.thickness);
			bottom.graphics.drawRect(r.left,r.bottom,r.width,this.thickness);
			left.graphics.drawRect(r.left,r.top,this.thickness,r.height);
			right.graphics.drawRect(r.right,r.top,this.thickness,r.height);
			top.graphics.drawRect(r.left/3,r.top,r.width/3,this.thickness);
			rightEdge.graphics.drawRect(r.right,r.bottom,thickness,r.height/2);
			leftEdge.graphics.drawRect(r.left,r.bottom,thickness,r.height/2);
		}
		/**
		 * Re-enables the sensors in case you decide you don't like them disabled.
		 */
		public function enable():void {
			this.visible=true;
		}
		/**
		 * Disables the sensors, just in case you think collisions might work without them (spoiler warning: they don't)
		 */
		public function disable():void {
			this.visible=false;
		}
	}
}