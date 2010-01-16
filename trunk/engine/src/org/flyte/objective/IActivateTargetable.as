package org.flyte.objective{
	import org.flyte.item.Collectible
	import org.flyte.events.GameEvent
	public interface IActivateTargetable{
		function target(e:GameEvent):void
	}
}