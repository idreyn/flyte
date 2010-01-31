package org.flyte.io{
	import flash.ui.Keyboard;
	/**
	 * The KeyControls class contains a set of constants that represent keyboard keycodes used in your game.
	 * For example, to test if the jump key has been pressed inside of an event handler for a GameEvent.KEY_DOWN event:
	 * <code>if(e.params.key == KeyControls.JUMP){}</code>
	 * @author Ian Reynolds
	 * 
	 */	
	public class KeyControls{
		/**
		 * Represents the key used to make the Character move right. By default it is Keyboard.RIGHT. 
		 */		
		public static var RIGHT:uint=Keyboard.RIGHT
		/**
		 * Represents the key used to make the Character move left. By default it is Keyboard.LEFT. 
		 */	
		public static var LEFT:uint=Keyboard.LEFT
		/**
		 * Represents the key used to make the Character jump. By default it is Keyboard.UP. 
		 */			
		public static var JUMP:uint=Keyboard.UP
		/**
		 * Represents the key used to make the Character throw. By default it is the Shift key
		 * Throwing is not implemented in the built-in Character class. 
		 */	
		public static var THROW:uint=16;
		/**
		 * Represents the key used to pause the game (the tilde ~ key). 
		 */
		public static var PAUSE:uint=192;
		
		 /**
		 * Represents the key used to make the Character move attack. Although it is an array, it only contains Keyboard.SPACE.
		 */			
		public static var ATTACKS:Array=[Keyboard.SPACE]
		/**
		 * This is really just here for your benefit, there is nothing built into the engine for this. 
		 */		
		public static var ACTIONS:Array=[Keyboard.DOWN]
		/**
		 * The ATTACK key that is used.
		 * @return ATTACKS[0]
		 * 
		 */	
		 
		public static function get ATTACK():uint{
			return ATTACKS[0]
		}
		/**
		 * The ACTION key that is used. 
		 * @return ACTIONS[0]
		 * 
		 */		
		public static function get ACTION():uint{
			return ACTIONS[0]
		}
	}
}