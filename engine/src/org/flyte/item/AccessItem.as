package org.flyte.item{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.objective.*;
	/**
	 * The AccessItem class defines a subclass of Collectible objects that have a target object. When the
	 * AccessItem is collected, it dispatches a GameEvent.TARGET to the target object, which will do with it what
	 * it will. If you don't feel like specifying the target object, just begin the target's instance name with the
	 * instance name of the AccessItem. Obviously you can change it later via the target property. Instances of AccessItem
	 * are by default permanent collectibles, meaning they will reappear when the world resets, possibly forcing you to collect
	 * them again to reactivate the target.
	 * @author Ian Reynolds
	 * 
	 */
	public dynamic class AccessItem extends Collectible{
		/**
		 * The GameMovieClips that the AccessItem will dispatch a GameEvent.TARGET to when collected. What each 
		 * target does with this is really up to it; it may do nothing, or it may start moving or something.
		 */
		public var targets:Array;
		/**
		 * Whether or not the AccessItem has any targets. To find targets, it looks through GameMovieClip.enum and
		 * searches for objects whose instance names begin with the name of the AccessItem.
		 */
		public var hasTarget:Boolean=false;
		public function AccessItem() {
			targets=new Array()
			permanent=true
			addEventListener(GameEvent.COLLECTED,onCollected);
			addEventListener(GameEvent.ADDED,onAddedF);
		}
		private function onAddedF(e:GameEvent):void {
			hasTarget=findTarget();
		}
		private function onCollected(e:GameEvent):void {
			if (hasTarget) {
				for(var i:uint=0;i<targets.length;i++){
					targets[i].dispatchEvent(new GameEvent(GameEvent.TARGET));
				}
				
			}
		}

		/**
		 * Forces the AccessItem to run its search for targets again.
		 * @return Whether the AccessItem has one or more targets.
		 * 
		 */
		public function findTarget():Boolean {
			var n:String=this.name;
			var b:Boolean=false;
			for(var i:uint=0; i<GameMovieClip.enum.length; i++) {
				var t:*=GameMovieClip.enum[i];
				var tn:String=t.name;
				if (tn.slice(0,n.length)==n&&t!=this) {
					targets.push(t)
					b=true;
				}
			}
			return b;
		}
	}
}