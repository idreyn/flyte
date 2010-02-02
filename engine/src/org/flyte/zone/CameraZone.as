package org.flyte.zone
{
	import org.flyte.character.Character
	import org.flyte.events.GameEvent;
	
	/**
	 * The CameraZone class represents a Zone object that prevents the camera (the world.camera object) from moving if it contains a 
	 * Character object, which is great for all sorts of things. 
	 * @author Ian Reynolds
	 * @see org.flyte.character.Character
	 * @see org.flyte.display.GameCamera
	 */
	public class CameraZone extends Zone
	{
		/**
		 * Whether the CameraZone object should prevent the camera from moving on the x-axis.
		 * @see org.flyte.display.GameCamera#trackX 
		 */
		public var disableX:Boolean=true
		/**
		 * Whether the CameraZone object should prevent the camera from moving on the y-axis.
		 * @see org.flyte.display.GameCamera#trackY 
		 */
		public var disableY:Boolean=true
		
		public function CameraZone()
		{
			addEventListener(GameEvent.ENTER,onEnter)
			addEventListener(GameEvent.EXIT,onExit)
		}
		
		private function onEnter(e:GameEvent):void
		{
			if(e.params.object == Character.current){
				if(disableX) world.camera.trackX=false
				if(disableY) world.camera.trackY=false
			}
		}
		
		private function onExit(e:GameEvent):void
		{
			if(e.params.object == Character.current){
				if(disableX) world.camera.trackX=true
				if(disableY) world.camera.trackY=true
			}
	}
}