package org.flyte.zone
{
	import org.flyte.base.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	import org.flyte.utils.Collection;
	public class Zone extends GameMovieClip
	{
		public var sensor:Sensors
		private var containsList:Collection
		private var collision:CollisionDictionary
		public function Zone()
		{
			
			collision=new CollisionDictionary()
			containsList=new Collection()
			collision.clear()
			sensor=new Sensors(this,5);
			this.alpha=0
			addLoopListener(onLoop)
			this.addResetListener(onReset)
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