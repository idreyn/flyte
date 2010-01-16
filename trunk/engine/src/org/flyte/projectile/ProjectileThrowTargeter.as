package org.flyte.projectile
{
	import org.flyte.base.*
	import org.flyte.events.*
	import org.flyte.projectile.*
	import org.flyte.world.*
	import org.flyte.utils.*
	
	import flash.utils.*
	import flash.geom.*
	
	public class ProjectileThrowTargeter extends GameMovieClip
	{
		public var c:Class
		public function ProjectileThrowTargeter()
		{
			visible=false
			c=flash.utils.getDefinitionByName(this.name.slice(this.name.indexOf("_")+1,this.name.length)) as Class
			addEventListener(GameEvent.ADDED,onAdded);
		}
		
		private function onAdded(e:GameEvent):void
		{
			var projectile:Projectile=new c();
			var p:Point=Game._root.world.globalToLocal(parent.localToGlobal(new Point(this.x,this.y)))
			projectile.go(500,GameMovieClip(parent.parent).scaleX>0?-180:180,2,Game._root.world)
			projectile.x=p.x
			projectile.y=p.y
			Game._root.world.addChild(projectile as Projectile)
		}
	}
}