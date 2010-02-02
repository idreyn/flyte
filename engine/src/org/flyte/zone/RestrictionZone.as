package org.flyte.zone
{
	import org.flyte.zone.*
	
	/**
	 * A RestrictionZone prevents a SelfControlledGameObject from leaving it. In a ScrollWorld, place a SelfControlledGameObject
	 * (like an Enemy) so it is touching the RestrictionZone and it will be confined to it. 
	 * @author Ian Reynolds
	 * @see org.flyte.base.SelfControlledGameObject
	 */
	public class RestrictionZone extends Zone
	{
		public static var enum:Array=new Array();
		
		public function RestrictionZone()
		{
			enum.push(this);
		}
	}
}