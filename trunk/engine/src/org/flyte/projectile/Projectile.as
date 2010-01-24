package org.flyte.projectile
{
	import com.coreyoneil.collision.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.utils.*;
	import org.flyte.world.*;
	public class Projectile extends GameMovieClip
	{
		public static var FRIENDLY_FIRE:Boolean=false;
		//public static var enum:Array=new Array();
		public var maxBounces:uint;
		public var power:Number;
		public var bounciness:Number=60
		public var minMaxBounces:uint;
		private var bounces:uint=0;
		private var fixBounce:uint=0;
		private var fall:uint=0;
		public var container:GameMovieClip;
		public var mass:Number;
		public var radius:Number;
		public var damageRadius:Number=0
		public var damage:Number=0
		private var invalidate:Boolean=false;
		private var bounceObject:GameMovieClip;
		private var sensors:Sensors;
		protected var _destroyed:Boolean=false
		public function Projectile()
		{
			sensors=new Sensors(this);
			addChild(sensors);
			sensors.right.height*=0.5;
			sensors.left.height*=0.5;
			sensors.alpha=0;
			//enum.push(this);
			action.mapAction(Action.STILL,"still",nothing);
			action.mapAction(Action.DESTROY,"destroy",destroyMe,false,false);
			action.setDefault(Action.STILL);
			action.setAction(Action.STILL);
			radius=Math.max(this.height,this.width);
			mass=radius*4;
		}
		private function looping(e:GameEvent):void
		{
			this.sensors.rotation=0-this.rotation;
			if (invalidate)
			{
				return;
			}

			this.x+=velocityX;
			this.y+=velocityY;
			this.velocityY++;
			power*=0.995;
			velocityX*=0.995;
			fall++;
			if (fixBounce>5)
			{
				if (! Collision.hitTestShape2(bounceObject,this))
				{
					fixBounce=0;
				}
			} else
			{
				for (var i:uint=0; i<Standable.enum.length; i++)
				{
					var t:GameMovieClip=Standable.enum[i];
					if (Collision.hitTestShape2(this,t))
					{
						dispatchEvent(new GameEvent(GameEvent.COLLISION))
						bounces++;
						bounceObject=t;
						fixBounce++;
						if (bounces<maxBounces)
						{
							bounceThis(t);
						} else
						{
							invalidate=true;
							
							destroyThis()
						}

						break;
					}
				}
			}
		}

		private function col(a:DisplayObject,b:DisplayObject):Boolean
		{
			return Collision.hitTestShape(a,b);
		}
		private function bounceThis(m:GameMovieClip):void
		{
			
			var immovable:Number=10000
			var collisions:CollisionList=new CollisionList(this,m);
			var res:Array=collisions.checkCollisions();
			var collision:Object=res[0];
			var angle:Number=collision.angle;
			var overlap:int=collision.overlapping.length;

			var sin:Number=Math.sin(angle);
			var cos:Number=Math.cos(angle);

			var velocityX0:Number=this.velocityX*cos+this.velocityY*sin;
			var velocityY0:Number=this.velocityY*cos-this.velocityX*sin;

			velocityX0 = ((this.mass - immovable) * velocityX0) / (this.mass + immovable);
			this.velocityX=velocityX0*cos-velocityY0*sin;
			this.velocityY=velocityY0*cos+velocityX0*sin;

			this.velocityX-=cos*overlap/this.radius;
			this.velocityY-=sin*overlap/this.radius;


			this.velocityY+=.75;
			this.velocityY*=bounciness / 100
			this.velocityX*=bounciness / 100

			this.x+=this.velocityX;
			this.y+=this.velocityY;


		}
		private function drawCollide(r:Rectangle):void
		{

		}
		public function go(power:Number,direction:Number,maxBounces:uint,container:GameMovieClip):void
		{
			this.power=power;
			this.velocityX=(Math.sin(direction)*power)/Game._root.stage.frameRate;
			this.velocityY=(Math.cos(direction)*power)/Game._root.stage.frameRate;
			this.rotation=direction;
			this.maxBounces=Math.max(maxBounces,minMaxBounces);
			this.container=container;
			addLoopListener(looping);
		}

		private function destroyMe():void
		{
			MovieClip(parent).removeChild(this);
		}

		private function reflect(v,n)
		{
			// R = V - 2 * (V · N)
			var d=dot(v,n);
			return {
			        x:v.x -2 * d * n.x,
			        y:v.y -2 * d * n.y 
			    };
		}

		// dot product of two vectors
		private function dot(v1,v2)
		{
			return (v1.x*v2.x) + (v1.y*v2.y);
		}

		// normalize vector (make length = 1)
		private function normalize(vector)
		{
			var len=getLength(vector);
			vector.x/=len;
			vector.y/=len;
			return vector;
		}

		// find the length of a vector
		private function getLength(v)
		{
			return Math.sqrt(v.x*v.x+v.y*v.y);
		}

		// find vector based on distance and angle
		private function getVector(distance,angle)
		{
			return {
			        x:distance*Math.sin(angle*(Math.PI/180)),
			        y:-distance*Math.cos(angle*(Math.PI/180))
			    };
		}
		
		
		public function destroyThis():void
		{
			_destroyed=true
			this.findBlastRadius()
			this.action.setAction(Action.DESTROY)
		}

		
		protected function findBlastRadius():void
		{
			if(damageRadius <= 0 || damage <= 0 ) return
			for (var i=0; i<GameObject.enum.length; i++)
			{
				var t:GameObject=GameObject.enum[i];
				if (Math.sqrt(Math.pow(this.x-t.x,2)+Math.pow(this.y-t.y,2))<damageRadius)
				{
					t.dispatchGameEvent(GameEvent.HIT,{sender:this,damage:this.damage,velocity:(this.x>t.x)?-5:5});
				}
			}
	
		}
	}
	
}
	
