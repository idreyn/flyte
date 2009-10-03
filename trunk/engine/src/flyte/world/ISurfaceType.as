package flyte.world{
	import flyte.base.GameObject
	import flyte.events.GameEvent
	public interface ISurfaceType{
		function placeObject(obj:GameObject):void
		function checkCollisions():void
		function onLoop(e:GameEvent):void
	}
}