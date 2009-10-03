package flyte.collision{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flyte.character.Character;
	import flyte.base.GameMovieClip;
	import flyte.events.GameEvent;
	
	/**
	 * 
	 * @author Ian Reynolds
	 * 
	 */
	public class Sensors extends GameMovieClip {
		private var thickness:uint;
		private var target:GameMovieClip;
		public var bottomLeft:Sprite;
		public var bottomRight:Sprite;
		public var bottomMiddle:Sprite;
		public var bottom:Sprite;
		public var left:Sprite;
		public var right:Sprite;
		public var top:Sprite;
		public var rightEdge:Sprite;
		public var leftEdge:Sprite;
		private var maxInstability=100;
		private var minInstability=2;
		private var hits:Dictionary;
		private var r:Rectangle;
		public function Sensors(t:GameMovieClip,thick:uint=1) {
			hits=new Dictionary();
			this.target=t;
			this.thickness=thick/t.scaleY
			drawSensors();
			this.alpha=0.0;
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
			left.graphics.lineStyle(thickness,0x0000FF);
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

		public function show():void {
			this.visible=true;
		}
		public function hide():void {
			this.visible=false;
		}
	}
}