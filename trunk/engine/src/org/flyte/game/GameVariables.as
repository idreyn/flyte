package org.flyte.game{
	import org.flyte.character.*;
	import org.flyte.world.*;
	/**
	 * The GameVariables class just holds a bunch of quick references to common game variables.
	 * I'll leave you to figure out what they do (or don't do), but since this class is dynamic, feel free to add your own. 
	 * @author Ian Reynolds
	 * 
	 */	
	public dynamic class GameVariables {
		public static var level:uint;
		public static var coins:uint;
		public static var maxJumps:uint=2
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