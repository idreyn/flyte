package flyte.projectile{
	import flyte.projectile.*;
	import flyte.base.*;
	import flyte.events.*;
	import flyte.collision.*;
	import flyte.display.*
	import flash.geom.*
	import flyte.utils.*
	import flash.display.*
	public class Projectile extends GameMovieClip {
		public static var FRIENDLY_FIRE:Boolean=false
		public static var enum:Array=new Array();
		public var maxBounces:uint;
		private var bounces:uint=0;
		private var bouncing:Boolean=false;
		public var container:GameMovieClip;
		private var invalidate:Boolean=false;
		private var bounceObject:GameMovieClip;
		public function Projectile() {
			enum.push(this);
			action.mapAction(Action.STILL,"still",nothing)
			action.mapAction(Action.DESTROY,"destroy",destroyMe,false,false)
			action.setDefault(Action.STILL)
			action.setAction(Action.STILL)
		}
		private function looping(e:GameEvent):void {
			if (invalidate) {
				return void;
			}
			this.x+=(velocityX/stage.frameRate);
			this.y+=(velocityY/stage.frameRate);
			if (bouncing) {
				if (! Collision.hitTestShape(bounceObject,this)) {
					bouncing=false;
				}
			} else {

				for (var i=0; i<Standable.enum.length; i++) {
					var t=Standable.enum[i];
					if (Collision.hitTestShape(this,t)) {
						bounces++;
						bounceObject=t
						bouncing=true
						if (bounces<maxBounces) {
							bounceThis(t);
						} else {
							invalidate=true;
							action.setAction(Action.DESTROY)
						}
						break;
					}
				}
			}
		}
		private function bounceThis(m:GameMovieClip):void{
			var r:Rectangle=Collision.complexIntersectionRectangle(this,m);
			var p:Point=parent.localToGlobal(new Point(this.x,this.y))
			var theta:Number=r2p(p.x,p.y,r.x,r.y);
			this.velocityX*=Math.sin(theta)
			this.velocityY*=Math.cos(theta)
			
												   
		}
		private function drawCollide(r:Rectangle):void{
			
		}
		public function go(power:Number,direction:Number,maxBounces:uint,container:GameMovieClip):void{
			this.velocityX=Math.sin(direction)*power
			this.velocityY=Math.cos(direction)*power
			this.rotation=direction
			this.maxBounces=maxBounces
			this.container=container
			addLoopListener(looping);
		}
		
		private function destroyMe():void{
			container.removeMe(this)
		}
	}
}