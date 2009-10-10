package org.flyte.item{
	import org.flyte.item.*;
	import org.flyte.base.*;
	import org.flyte.objective.*;
	import org.flyte.events.*;
	public class AccessItem extends Collectible {
		public var target:GameMovieClip;
		public var hasTarget:Boolean=false;
		public function AccessItem() {
			permanent=true
			addEventListener(GameEvent.COLLECTED,onCollected);
			addEventListener(GameEvent.ADDED,onAddedF);
		}
		private function onAddedF(e:GameEvent):void {
			hasTarget=findTarget();
		}
		public function onCollected(e:GameEvent):void {
			if (hasTarget) {
				target.dispatchEvent(new GameEvent(GameEvent.TARGET));
				
			}
		}

		public function findTarget():Boolean {
			var n:String=this.name;
			var b:Boolean=false;
			for(var i:uint=0; i<ActivateTargetable.enum.length; i++) {
				var t:*=ActivateTargetable.enum[i];
				var tn:String=t.name;
				if (tn.slice(0,n.length)==n&&t!=this&&t is IActivateTargetable) {
					target=t;
					b=true;
					break;
				}
			}
			trace(b)
			return b;
		}
	}
}