package org.flyte.media
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.utils.*;
	
	/**
	 * The WorldSound class creates the illusion of dimensional sound (panning and volume) based on the position of a GameMovieClip.
	 * So the farther away from the camera the specified GameMovieClip is, the quieter the sound will be and the more it will pan to the
	 * left or right speaker. 
	 * @author Ian
	 * 
	 */
	public class WorldSound extends GameMovieClip
	{
		private var _parent:GameMovieClip
		private var channel:SoundChannel
		private var stransform:SoundTransform
		private var sound:Sound
		/**
		 * Creates a new WorldSound object. 
		 * @param s A Sound object to play through the WorldSound.
		 * @param d The GameMovieClip the sound is "coming from".
		 * 
		 */
		public function WorldSound(s:Sound,d:GameMovieClip){
			
			this._parent=d
			this.sound=s
			sound.addEventListener(Event.COMPLETE,onSoundComplete)
			channel=sound.play()
			_parent.addEventListener(Event.ENTER_FRAME,onLoop)
			Game._root.addEventListener(GameEvent.PAUSE,onPause)
			Game._root.addEventListener(GameEvent.RESUME,onResume)
		}
		
		private function onSoundComplete(e:GameEvent):void
		{
			Game._root.removeEventListener(GameEvent.PAUSE,onPause)
			Game._root.removeEventListener(GameEvent.RESUME,onResume)
			_parent.removeEventListener(Event.ENTER_FRAME,onLoop)
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
			