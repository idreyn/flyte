package blizzard
{
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.media.*;
	import org.flyte.projectile.*;
	
	/**
	 * @private 
	 * @author Ian
	 * 
	 */
	public class ChristmasBulb extends Projectile
	{
		public function ChristmasBulb()
		{
			this.damage=10
			this.damageRadius=300
			this.maxBounces=1
			addLoopListener(onLoop)
			addEventListener(GameEvent.COLLISION,onCollision)
		}
		
		private function onLoop(e:GameEvent):void
		{
			this.rotation+=Math.abs(this.velocityY)
																		 
		}
		
		private function onCollision(e:GameEvent):void
		{
			//if(action.current == Action.STILL) addChild(new WorldSound(new ClinkSound(),this))
		}
	}
}
