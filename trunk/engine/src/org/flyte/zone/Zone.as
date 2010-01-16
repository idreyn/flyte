package org.flyte.zone
{
	import org.flyte.base.*;
	import org.flyte.character.Character;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	public class Zone extends GameMovieClip
	{
		public var sensor:Sensors
		public function Zone()
		{
			sensor=new Sensors(this,5);
			this.visible=false;

		}
	}
}