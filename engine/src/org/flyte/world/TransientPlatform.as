package org.flyte.world{
	import org.flyte.world.Platform
	/**
	 * A TransientPlatform is a Platform that you can jump through and land on. In other words, it only has a floor. 
	 * @author Ian
	 * 
	 */
	public class TransientPlatform extends Platform{
		public function TransientPlatform(){
			super(false)
		}

	}
}