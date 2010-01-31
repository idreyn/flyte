package org.flyte.world
{
	import org.flyte.base.*
	import org.flyte.events.*
	import org.flyte.objective.*
	import org.flyte.world.*
	public class RemoteActivatedPlatform extends ActivatablePlatform
	{
		public var deactivateOnReset:Boolean=false
		public function RemoteActivatedPlatform()
		{
			access=true
			addEventListener(GameEvent.TARGET,target)
			addResetListener(onReset)
		}
	
		public function target(e:GameEvent):void
		{
			access=false
		}
		
		private function onReset(e:GameEvent):void
		{
			if(deactivateOnReset)
			{
				stopMotion();
				access=true
			}
		}

	}
}
												
												 