package org.flyte.projectile{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.projectile.*
	public class ProjectileEmitter extends GameMovieClip{
		private var _type:Class=org.flyte.projectile.Projectile
		public function set type(t:Class):void{
			if(new type() is Projectile){
				_type=t
			}else{
				throw new Error("Flyte Error: the type property of a ProjectileEmitter must refer to a class that extends org.flyte.projectile.Projectile")
			}
		}
		public function get type():Class{
			return _type
		}
		public function emit(power:Number,direction:Number,maxBounces:uint=0):void{
			if(! power>0) return void;
			var p:*=new _type();
			addChild(p)
			Projectile(p).go(power,direction,maxBounces,this)
		}
	}
}