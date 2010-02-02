package org.flyte.zone
{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	import org.flyte.utils.Collection;
	/**
	 * A Zone object is a GameMovieClip that dispatches GameEvent.ENTER when a GameObject enters it and GameEvent.EXIT when
	 * a GameObject exits it. The object that entered or extied can be accessed through the GameEvent's params.object property.
	 * Zones are useful creatures; you can use them to kill GameObjects, reverse gravity, etc. Go wild.
	 * @author Ian Reynolds
	 * @see org.flyte.base.GameObject
	 * @see org.flyte.events.GameEvent#params
	 */
	public class Zone extends GameMovieClip
	{
		private var containsList:Collection
		private var collision:CollisionDictionary
		
		private var _isVisible:Boolean=false
		
		public function Zone()
		{
			
			collision=new CollisionDictionary()
			containsList=new Collection()
			collision.clear()
			this.alpha=0
			addLoopListener(onLoop)
			this.addResetListener(onReset)
		}
		
		public function set isVisible(b:Boolean):void
		{
			if(b){
				this.alpha=1
			}else{
				this.alpha=0
			}
		}
		
		public function get isVisible():Boolean
		{
			return alpha>0
		}
		
		private function onReset(e:GameEvent):void
		{
			collision.clear()
		}
		
		private function onLoop(e:GameEvent):void
		{
			for(var i:uint=0;i<GameObject.enum.length;i++){
				var t:GameObject=GameObject.enum[i]
				if(Collision.hitTestShape(this,t))
				{
					if(!collision.isCollisionAt(i,CollisionType.GENERAL))
					{
						dispatchEvent(new GameEvent(GameEvent.ENTER,{object:t}))
						t.dispatchEvent(new GameEvent(GameEvent.ENTER))
						containsList.add(t)
						collision.setCollisionAt(i,CollisionType.GENERAL)
					}
				}else{
					if(collision.isCollisionAt(i,CollisionType.GENERAL))
					{
						dispatchEvent(new GameEvent(GameEvent.EXIT,{object:t}))
						t.dispatchEvent(new GameEvent(GameEvent.EXIT))
						containsList.remove(t)
						collision.endCollisionAt(i,CollisionType.GENERAL)
					}
				}
			}
		}
			
	}
}