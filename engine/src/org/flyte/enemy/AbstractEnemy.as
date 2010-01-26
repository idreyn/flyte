package org.flyte.enemy{
	import org.flyte.base.SelfControlledGameObject;
	import org.flyte.events.*;
	import org.flyte.game.FactionManager;
	public class AbstractEnemy extends SelfControlledGameObject{
		/*AbstractEnemy is really just a way of being sure that a SelfControlledGameObject is indeed trying to
		hurt your beloved Character. (I don't know what else it would be, given the black-and-white,
		good-versus-evil nature of most platform games.) */
		public function AbstractEnemy(){
			this.faction=FactionManager.BAD
			addEventListener(GameEvent.DIE,onDie)
		}
		
		private function onDie(e:GameEvent):void
		{
			world.dispatchEvent(new GameEvent(GameEvent.ENEMY_DIE,{object:this}))
		}
			
		
	}
}