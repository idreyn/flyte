package org.flyte.world{
	import flash.geom.*;
	
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	import org.flyte.motion.*;
	/**
	 * A Platform object is something GameObjects can stand on.
	 * @author Ian 
	 * 
	 */
	public class Platform extends Standable{
		public var ceiling:Ceiling;
		public var floor:Floor;
		public var leftWall:LeftWall;
		public var rightWall:RightWall;
		protected var thickness:uint=10;
		protected var initAllSurfaces:Boolean=true;
		/**
		 * An array of all GameObjects standing on the platform. 
		 */
		public var gameObjectsOnMe:Array;
		private var lastX:Number;
		private var lastY:Number;
		public static var enum:Array=new Array();
		/**
		 * Synchronizes the movement of two platforms so they move at the same rate. 
		 * @param t The time, in seconds, that the platforms' tweens will take.
		 * @param p1 One of the platforms to sync.
		 * @param p2 The other platform to sync.
		 * 
		 */
		public static function sync(t:uint,p1:Platform,p2:Platform):void{
			if(t>0){
				//p1.time=p2.time=t*Game._root.stage.frameRate
			}
		}
		public function Platform(initAllSurfaces:Boolean=true) {
			this.initAllSurfaces=initAllSurfaces
			createBoundaries(this.getBounds(this));
			lastX=this.x;
			lastY=this.y;
			gameObjectsOnMe=new Array();
			addLoopListener(onLoop);
			addEventListener(GameEvent.ADDED,onAdded)
		}
		
		private function onAdded(e:GameEvent):void
		{
		}
		/**
		 * Sets the bounciness of the Platform. 
		 * @param val The bounciness value.
		 * @param valX The amount the Platform will bounce its bouncees left or right.
		 * 
		 */
		public function setBounce(val:Number,valX:Number=0):void {
			this.bounce=Math.abs(val);
			floor.bounceX=valX;
		}
		
		/**
		 * Sets the amount of air GameObjects will get when jumping on this bad boy. 
		 * @param val The value to use.
		 * 
		 */
		public function setJumpHeight(val:Number):void {
			this.jumpHeight=Math.abs(val);
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
			ceiling.graphics.drawRect(r.left,r.top+r.height/2,r.width,r.height-(r.height/2));
			floor.graphics.drawRect(r.left,r.top,r.width,r.height/2);
			leftWall.graphics.drawRect(r.left,r.top,r.width,r.height);
			rightWall.graphics.drawRect(r.left,r.top,r.width,r.height);
			
			if (initAllSurfaces) {
				addChild(ceiling);
				addChild(leftWall);
				addChild(rightWall);
			}
			addChild(floor);
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
			for(var i:uint=0; i<GameObject.enum.length; i++) {
				if (gameObjectsOnMe[i]) {
					GameObject.enum[i].x+=this.velocityX;
					GameObject.enum[i].y+=this.velocityY;
				}
			}
		}

	}
}