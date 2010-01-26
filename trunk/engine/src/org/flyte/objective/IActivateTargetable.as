package org.flyte.objective{
	import org.flyte.item.Collectible
	import org.flyte.events.GameEvent
	public interface IActivatable{
		function target(e:GameEvent):void
	}
}