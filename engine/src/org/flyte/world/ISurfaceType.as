package org.flyte.world{
	import org.flyte.base.GameObject
	import org.flyte.events.GameEvent
	public interface ISurfaceType{
		function placeObject(obj:GameObject):void
		function checkCollisions():void
		function onLoop(e:GameEvent):void
	}
}