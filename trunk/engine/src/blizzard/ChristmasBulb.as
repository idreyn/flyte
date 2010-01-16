package blizzard
{
	import org.flyte.projectile.*
	import org.flyte.events.*
	import org.flyte.character.*
	import org.flyte.collision.*
	import org.flyte.media.*
	import org.flyte.base.*
	import org.flyte.display.*
	
	public class ChristmasBulb extends Bomb
	{
		public function ChristmasBulb()
		{
			this.damage=100
			addLoopListener(onLoop)
			addEventListener(GameEvent.COLLISION,onCollision)
		}
		
		private function onLoop(e:GameEvent):void
		{
			this.rotation+=Math.abs(this.velocityY)
																		 
		}
		
		private function onCollision(e:GameEvent):void
		{
			if(action.current == Action.STILL) addChild(new WorldSound(new ClinkSound(),this))
		}
	}
}
