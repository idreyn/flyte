package org.flyte.projectile
{
	import flash.geom.*;
	import flash.utils.*;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.utils.*;
	import org.flyte.world.*;
	
	/**
	 * A ProjectileThrowTargeter is an object designed to be placed inside of a throw action MovieClip.
	 * When the MovieClip passes a frame with the ProjectileThrowTargeter, it will emit a new Projectile of type
	 * className into the current world. To specify the class to use without Actionscript, give the object an instance name
	 * that includes an underscore ("_") followed by the name of the class to throw.
	 * @author Ian Reynolds
	 * @see org.flyte.projectile.Projectile
	 */
	public class ProjectileThrowTargeter extends GameMovieClip
	{
		/**
		 * The class of Projectile to throw. 
		 */
		public var className:Class
		/**
		 * The power property of thrown Projectiles. 
		 * @see org.flyte.projectile.Projectile#power
		 */
		public var power:Number=500
		/**
		 * The maxBounces property of thrown Projectiles.
		 * @see org.flyte.projectile.Projectile#maxBounces
		 */
		public var maxBounces:uint=2
		/**
		 * When the ProjectileThrowTargeter constructs, it won't do anything until it is added to the stage,
		 * which should happen every time the animation is played. 
		 * @see org.flyte.events.GameEvent#ADDED
		 */
		public function ProjectileThrowTargeter()
		{
			visible=false
			className=flash.utils.getDefinitionByName(this.name.slice(this.name.indexOf("_")+1,this.name.length)) as Class
			addEventListener(GameEvent.ADDED,onAdded);
		}
		
		private function onAdded(e:GameEvent):void
		{
			var projectile:Projectile=new className();
			var p:Point=world.globalToLocal(parent.localToGlobal(new Point(this.x,this.y)))
			projectile.go(power,GameMovieClip(parent.parent).scaleX>0?-180:180,maxBounces,world)
			projectile.x=p.x
			projectile.y=p.y
			world.addChild(projectile as Projectile)
		}
	}
}