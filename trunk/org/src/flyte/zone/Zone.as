package flyte.zone
{
	import flyte.base.*;
	import flyte.character.Character;
	import flyte.collision.*;
	import flyte.events.*;
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