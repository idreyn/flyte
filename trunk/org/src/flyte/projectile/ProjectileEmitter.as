package flyte.projectile{
	import flyte.events.*
	import flyte.base.*
	import flyte.projectile.*
	public class ProjectileEmitter extends GameMovieClip{
		private var _type:Class=flyte.projectile.Projectile
		public function set type(t:Class):void{
			if(new type() is Projectile){
				_type=t
			}else{
				throw new Error("Flyte Error: the type property of a ProjectileEmitter must refer to a class that extends flyte.projectile.Projectile")
			}
		}
		public function get type():Class{
			return _type
		}
		public function emit(power:Number,direction:Number,maxBounces:uint=0):void{
			if(! power>0) return void;
			var p=new _type();
			addChild(p)
			p.go(power,direction,maxBounces,this)
		}
	}
}