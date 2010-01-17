package org.flyte.media
{
	import org.flyte.base.*
	import org.flyte.events.*
	import org.flyte.display.*
	import org.flyte.utils.*
	import org.flyte.character.*
	
	import flash.media.*
	import flash.display.*
	import flash.events.*
	
	public class WorldSound extends GameMovieClip
	{
		private var _parent:GameMovieClip
		private var channel:SoundChannel
		private var stransform:SoundTransform
		private var sound:Sound
		public function WorldSound(s:Sound,d:GameMovieClip){
			
			this._parent=d
			this.sound=s
			channel=sound.play()
			_parent.addEventListener(Event.ENTER_FRAME,onLoop)
			Game._root.addEventListener(GameEvent.PAUSE,onPause)
			Game._root.addEventListener(GameEvent.RESUME,onResume)
		}
		
		private function onLoop(e:Event):void
		{
			stransform=new SoundTransform();
			stransform.pan=((Character.current.x-this._parent.x)/1000)
			var dx:Number=_parent.x-Character.current.x
			var dy:Number=_parent.y-Character.current.y
			var distance:Number=Math.sqrt( Math.pow(dx,2) + Math.pow(dy,2))
			var max:Number=1000
			stransform.volume=1-(distance/max)
			channel.soundTransform=stransform
		}
		
		private function onPause(e:GameEvent):void
		{
		}
		
		private function onResume(e:GameEvent):void
		{
		}
	}
}
			