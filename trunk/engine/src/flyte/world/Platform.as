package flyte.world{
	import flash.geom.*;
	import flyte.collision.*;
	import flyte.base.*;
	import flyte.world.*;
	import flyte.events.*;
	import flyte.motion.*
	public class Platform extends MotionTargetedGMC{
		public var ceiling:Ceiling;
		public var floor:Floor;
		public var leftWall:LeftWall;
		public var rightWall:RightWall;
		protected var thickness:uint=10;
		protected var initAllSurfaces:Boolean=true;
		protected var gameObjectsOnMe:Array;
		private var lastX:Number;
		private var lastY:Number;
		private var bounce:Number=0;
		public static var enum:Array=new Array();
		public static function sync(t:uint,p1:Platform,p2:Platform):void{
			if(t>0){
				p1.time=p2.time=t*Game._root.stage.frameRate
			}
		}
		public function Platform(initAllSurfaces:Boolean=true) {
			this.initAllSurfaces=initAllSurfaces
			createBoundaries(this.getBounds(this));
			lastX=this.x;
			lastY=this.y;
			gameObjectsOnMe=new Array();
			Standable.enum.push(this)
			addLoopListener(onLoop);
		}
		public function setBounce(val:Number,valX:Number=0):void {
			floor.bounce=Math.abs(val);
			floor.bounceX=valX;
		}
		public function setFriction(val:Number):void {
			floor.friction=Math.abs(val);
		}
		public function setJumpHeight(val:Number):void {
			floor.jumpHeight=Math.abs(val);
		}
		private function createBoundaries(r:Rectangle):void {
			ceiling=new Ceiling();
			floor=new Floor();
			leftWall=new LeftWall();
			rightWall=new RightWall();
			ceiling.graphics.beginFill(0x000000,0);
			floor.graphics.beginFill(0x000000,0);
			leftWall.graphics.beginFill(0x0000000,0);
			rightWall.graphics.beginFill(0x000000,0);
			ceiling.graphics.drawRect(r.left,r.top,r.width,r.height);
			floor.graphics.drawRect(r.left,r.top,r.width,r.height);
			leftWall.graphics.drawRect(r.left,r.top,r.width,r.height);
			rightWall.graphics.drawRect(r.left,r.top,r.width,r.height);
			addChild(floor);
			if (initAllSurfaces) {
				addChild(ceiling);
				addChild(leftWall);
				addChild(rightWall);
			}
			floor.addEventListener(GameEvent.ENTER_PLATFORM,onPlatform);
			floor.addEventListener(GameEvent.LEAVE_PLATFORM,leavePlatform);
		}
		private function onPlatform(e:GameEvent):void {
			gameObjectsOnMe[e.params.index]=true;
		}
		private function leavePlatform(e:GameEvent):void {
			gameObjectsOnMe[e.params.index]=false;

		}
		private function onLoop(e:GameEvent):void {
			velocityX=this.x-lastX;
			velocityY=this.y-lastY;
			lastX=this.x;
			lastY=this.y;
			for (var i=0; i<GameObject.enum.length; i++) {
				if (gameObjectsOnMe[i]) {
					GameObject.enum[i].x+=this.velocityX;
					GameObject.enum[i].y+=this.velocityY;
				}
			}
		}

	}
}