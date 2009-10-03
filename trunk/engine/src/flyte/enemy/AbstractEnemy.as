package flyte.enemy{
	import flyte.base.SelfControlledGameObject
	import flyte.game.FactionManager
	public class AbstractEnemy extends SelfControlledGameObject{
		/*AbstractEnemy is really just a way of being sure that a SelfControlledGameObject is indeed trying to
		hurt your beloved Character. (I don't know what else it would be, given the black-and-white,
		good-versus-evil nature of most platform games.) */
		public function AbstractEnemy(){
			this.faction=FactionManager.BAD
		}
		
	}
}