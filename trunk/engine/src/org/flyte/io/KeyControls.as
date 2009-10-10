package org.flyte.io{
	import flash.ui.Keyboard
	public class KeyControls{
		public static var RIGHT:uint=Keyboard.RIGHT
		public static var LEFT:uint=Keyboard.LEFT
		public static var JUMP:uint=Keyboard.UP
		public static var ATTACKS:Array=[Keyboard.SPACE]
		public static var ACTIONS:Array=[Keyboard.DOWN]
		public static function get ATTACK():uint{
			return ATTACKS[0]
		}
		public static function get ACTION():uint{
			return ACTIONS[0]
		}
	}
}