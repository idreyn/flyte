package blizzard
{
	import org.flyte.events.GameEvent;
	import org.flyte.item.Collectible;
	import org.flyte.character.Character
	/**
	 * @private 
	 * @author Ian
	 * 
	 */
	public class FlightPowerup extends Collectible
	{
		public function FlightPowerup(){
			addEventListener(GameEvent.COLLECTED,onCollected)
		}
		
		private function onCollected(e:GameEvent):void
		{
			Character.current.jumpDampingHold=1.05
		}
	}
}