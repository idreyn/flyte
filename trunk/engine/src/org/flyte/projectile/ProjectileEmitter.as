package org.flyte.projectile{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.projectile.*
	/**
	 * A ProjectileEmitter is a GameMovieClip that emits Projectiles. Seriously! Just add one to the stage and
	 * try it. It's fun.
	 * @author Ian Reynolds
	 * 
	 */
	public class ProjectileEmitter extends GameMovieClip{
		private var _type:Class=org.flyte.projectile.Projectile
		/**
		 * A ProjectileEmitter takes a type parameter referring to the class of Projectiles it creates.
		 * For instance, to emit a class called NinjaStar that extends Projectile, set the type property of 
		 * the ProjectileEmitter to NinjaStar.
		 * @param t The class of the Projectile to throw.
		 * 
		 */
		public function set type(t:Class):void{
			if(new type() is Projectile){
				_type=t
			}else{
				throw new Error("Flyte Error: the type property of a ProjectileEmitter must refer to a class that extends org.flyte.projectile.Projectile")
			}
		}
		/**
		 * Gives the class name of the projectile we're emitting.
		 * @return The type of projectile that is being emitted.
		 * 
		 */
		public function get type():Class{
			return _type
		}
		/**
		 * Emits a projectile of class type. 
		 * @param power The power of the new Projectile.
		 * @param direction The direction of the new Projectile.
		 * @param maxBounces The maxBounces of the new Projectile.
		 * @see org.flyte.projectile.Projectile#go
		 */
		public function emit(power:Number,direction:Number,maxBounces:uint=0):void{
			if(! power>0) return void;
			var p:*=new _type();
			parent.addChild(p)
			p.x=this.x
			p.y=this.y
			Projectile(p).go(power,direction,maxBounces,this)
		}
	}
}