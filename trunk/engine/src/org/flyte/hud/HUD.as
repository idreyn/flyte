package org.flyte.hud
{
	import flash.display.*
	
	import org.flyte.display.*
	import org.flyte.events.*
	import org.flyte.character.*
	import org.flyte.base.*
	/**
	 * The HUD class is just a wrapper for a MovieClip that the Game loads above the current ScrollWorld. 
	 * It is set with the loadWorld() or setHUD() method of a Game object. Usually it would contain a health
	 * indicator, etc, and maybe a logo or something. In any case, to use it just create a MovieClip in your
	 * library and populate it with all this stuff. Then create a new instance of it and pass it to one of the
	 * methods I mentioned.
	 * @author Ian Reynolds
	 * @see org.flyte.base.Game#loadWorld
	 * @see org.flyte.base.Game#setHUD
	 */	
	public dynamic class HUD extends MovieClip
	{
	}
}