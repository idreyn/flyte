package org.flyte.base{
	import org.flyte.base.GameObject
		/**
		* Oddly enough, a NonDestroyableGameObject can't be destroyed. It will still register GameEvent.HIT but
		 * you'll probably want to override GameObject::onHit(e:GameEvent):void to suit your own needs. It also
		 * won't show a health bar.
		 * @author Ian Reynolds
		 * @see GameObject
		 * @see org.flyte.events.GameEvent#HIT
		 */
	public class NonDestroyableGameObject extends GameObject{
		public function NonDestroyableGameObject(){
			destroyable=false
			super()
		}
	}
}
		