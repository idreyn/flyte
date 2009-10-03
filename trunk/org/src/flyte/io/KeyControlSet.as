package flyte.io{
	import flash.ui.Keyboard
	public class KeyControlSet{
		public var MOVE_RIGHT:uint=Keyboard.RIGHT
		public var MOVE_LEFT:uint=Keyboard.LEFT
		public var JUMP:uint=Keyboard.UP
		public var ATTACKS:Array=[Keyboard.SPACE]
		public var ACTIONS:Array=[Keyboard.DOWN]
		public function KeyControlSet(){
		}
	}
}