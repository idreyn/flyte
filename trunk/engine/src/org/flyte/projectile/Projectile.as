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
	/**
	 * A Projectile is a GameMovieClip that is launched, thrown, or otherwise exhibits projectile behavior.
	 * It is recommended that you use a ProjectileEmitter or ProjectileThrowTargeter to create projectiles. 
	 * A Projectile can take many forms, from anywhere from a bomb to a small tractor, but it will generally exhibit
	 * one of two behaviors: either it keeps moving in a straight line like a bullet (which does not happen in real life)
	 * or it arcs much like a baseball. Projectiles will bounce off of all Standable objects but won't interact with GameMovieClips
	 * unless you tell them to. The Projectile's ActionManager requires two name/frame combos: "still" and "destroy".
	 * @author Ian Reynolds
	 * @see org.flyte.projectile.ProjectileThrowTargeter
	 * @see org.flyte.projectile.ProjectileEmitter
	 * @see org.flyte.collision.Standable
	 * @see org.flyte.display.ActionManager
	 */
	public class Projectile extends TransientObject
	{
		/**
		 * The number of bounces the Projectile can take before it destructs.
		 */
		public var maxBounces:uint;
		/**
		 * The speed of the projectile.
		 */
		public var power:Number;
		/**
		 * How bouncy the projectile is. This isn't really quantifiable; just...trust me.
		 */
		public var bounciness:Number=60
		/**
		 * The minimum value for the maxBounces property, if that makes any sense. 
		 */
		public var minMaxBounces:uint;
		private var bounces:uint=0;
		private var fixBounce:uint=0;
		private var fall:uint=0;
		/**
		 * The object that contains the Projectile. With any luck, it should be a ScrollWorld. 
		 */
		public var container:GameMovieClip;
		/**
		 * The mass of the projectile. Just ignore this, physics buffs. 
		 */
		public var mass:Number;
		/**
		 * The size of the projectile, or the radius of an imaginary circle drawn around it. 
		 * Take the hint, Projectiles should be relatively round.
		 */
		public var radius:Number;
		/**
		 * Why throw something if not to harm something else? The damageRadius property specifies the 
		 * maximum distance a GameObject can be from the Projectile when it destroys to
		 * receive damage from it. 
		 */
		public var damageRadius:Number=0
		/**
		 * The amount of damage given to any GameObjects inside of the damageRadius. Keep in mind that 
		 * the default health value for GameObjects is 100.
		 */
		public var damage:Number=0
		/**
		 * Whether to try to damage GameObjects when the Projectile destroys. Set to false if you want to 
		 * create wussy projectiles or implement your own damage system. 
		 */
		public var useDamage:Boolean=true
		/**
		 * Whether the Projectile moves like a bullet (true) or like a baseball (false). 
		 */
		public var bullet:Boolean=false
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
			if(!bullet){
				
			this.velocityY++;
			power*=0.995;
			velocityX*=0.995;
			fall++;
			}
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
			//Props to CollisionKit!
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
		/**
		 * Sends the Projectile on its merry way. Remember, Projectiles won't start moving until you
		 * call their go function. Of course, ProjectileEmitters and ProjectileThrowTargeters do this automatically.
		 * @param power The power, or speed of the Projectile.
		 * @param direction The direction the Projectile should move; an angle value.
		 * @param maxBounces The maximum number of bounces the Projectile can take.
		 * @param container The object that contains the Projectile, should be a ScrollWorld.
		 * 
		 */
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
			this.removeEventListener(GameEvent.LOOP,looping)
			GameMovieClip(parent).killChild(this)
		}
		
		/**
		 * Destroys the Projectile. 
		 * 
		 */
		public function destroyThis():void
		{
			_destroyed=true
			if(useDamage) this.findBlastRadius()
			this.action.setAction(Action.DESTROY)
		}

		
		protected function findBlastRadius():void
		{
			if(damageRadius <= 0 || damage <= 0 ) return
			for (var i:uint=0; i<GameObject.enum.length; i++)
			{
				var t:GameObject=GameObject.enum[i];
				if (Math.sqrt(Math.pow(this.x-t.x,2)+Math.pow(this.y-t.y,2))<damageRadius)
				{
					t.dispatchGameEvent(GameEvent.HIT,{sender:this,damage:this.damage,velocity:(this.x>t.x)?-1:1});
				}
			}
	
		}
	}
	
}
	
