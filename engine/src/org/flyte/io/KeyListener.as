package org.flyte.io{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.flyte.base.*;
	import org.flyte.events.*;
	/**
	 * A KeyListener object dispatches events when keys are pressed and released.
	 * Accessed through the key propery of a ScrollWorld.
	 * @author Ian
	 * @see org.flyte.world.ScrollWorld#key
	 */	
	public class KeyListener extends GameMovieClip {
		private var keyList:Array=new Array();
		public function KeyListener() {
			this.addEventListener(GameEvent.ADDED,onAdded);
			
		}
		private function onAdded(event:Event=null):void {
			world.addEventListener(GameEvent.LOAD_WORLD,onAdded)
			world.addEventListener(GameEvent.UNLOAD_WORLD,onUnloadWorld)
			world.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			world.stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);
			for(var i:uint=0; i<255; i++) {
				keyList[i]=false;
			}
		}
		
		private function onUnloadWorld(e:GameEvent):void
		{
			world.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			world.stage.removeEventListener(KeyboardEvent.KEY_UP,keyUp);
		}
		private function keyDown(event:KeyboardEvent):void {
			keyList[event.keyCode]=true;
			dispatchEvent(new GameEvent(GameEvent.KEY_DOWN,{key:event.keyCode}));
		}
		private function keyUp(event:KeyboardEvent):void {
			keyList[event.keyCode]=false;
			dispatchEvent(new GameEvent(GameEvent.KEY_UP,{key:event.keyCode}));
		}
		/**
		 * Checks whether a key is currently pressed.
		 * @param keycode The keycode of the key to check
		 * @return A boolean indicating whether said key has been pressed.
		 * 
		 * 
		 */		
		public function isDown(keycode:uint):Boolean {
			return keyList[keycode];
		}
		/**
		 * Gets an array of all the keys pressed right now. 
		 * @return A (IMHO) useless array of all keys pressed at the moment.
		 * 
		 */		
		public function getKeysdown():Array {
			var a:Array=new Array();
			for(var i:uint=0; i<255; i++) {
				if (keyList[i]) {
					a.push(i);
				}
			}
			return a;
		}
	}
}