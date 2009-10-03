package flyte.world
{
	import flyte.base.*
	import flyte.events.*
	import flyte.objective.*
	import flyte.world.*
	public class RemoteActivatedPlatform extends ActivatablePlatform implements IActivateTargetable
	{
		public var deactivateOnReset:Boolean=false
		public function RemoteActivatedPlatform()
		{
			ActivateTargetable.enum.push(this)
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
												
												 