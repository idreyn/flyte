package org.flyte.world
{
	import org.flyte.base.*
	import org.flyte.events.*
	import org.flyte.objective.*
	import org.flyte.world.*
	/**
	 * A RemoveActivatedPlatform is an ActivatablePlatform that sets needsAccess to false when it 
	 * receives GameEvent.TARGET, thus allowing it to start moving. 
	 * @author Ian
	 * 
	 */
	public class RemoteActivatedPlatform extends ActivatablePlatform
	{
		/**
		 * Whether the RemoteActivatedPlatform should deactivate when the world resets, forcing you
		 * to go back and re-activate it somehow. 
		 */
		public var deactivateOnReset:Boolean=false
		/**
		 * By default, the RemoteActivatedPlatform will not start moving until it receives GameEvent.TARGET and the
		 * Character sets foot on it. 
		 * 
		 */
		public function RemoteActivatedPlatform()
		{
			needsAccess=true
			addEventListener(GameEvent.TARGET,target)
			addResetListener(onReset)
		}
	
		private function target(e:GameEvent):void
		{
			needsAccess=false
		}
		
		private function onReset(e:GameEvent):void
		{
			if(deactivateOnReset)
			{
				stopMotion();
				needsAccess=true
			}
		}

	}
}
												
												 