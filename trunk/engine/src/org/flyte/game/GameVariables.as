package org.flyte.game{
	import org.flyte.character.*;
	import org.flyte.world.*;
	public dynamic class GameVariables {
		public static var level:uint;
		public static var coins:uint;
		public static var maxJumps:uint=1
		//This class is dynamic, you can add your own properties wherever you please.
		public static function get health():uint {
			return Character.current.health;
		}
		public static function set health(i:uint):void {
			Character.current.health=i;
		}
		public static function get lives():uint {
			return Character.current.lives;
		}
		public static function set lives(i:uint):void {
			Character.current.lives=i;
		}
		public static function get attackPower():uint{
			return Character.current.attackPower
		}
		public static function set attackPower(i:uint):void{
			Character.current.attackPower=i
		}
	}
}