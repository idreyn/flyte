package flyte.objective{
	import flyte.item.Collectible
	import flyte.events.GameEvent
	public interface IActivateTargetable{
		function target(e:GameEvent):void
	}
}