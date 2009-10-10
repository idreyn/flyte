package org.flyte.enemy{
	import org.flyte.base.*
	import org.flyte.events.*
	import org.flyte.collision.*
	import org.flyte.character.*;
	public class FollowEnemy extends GameObject{
		protected var seesCharacter:Boolean=true
		public function FollowEnemy(){
			velocityX=1
			addLoopListener(onLoop)
		}
		private function onLoop(e:GameEvent):void{	
			if(seesCharacter){this.velocityX=(this.x > Game._root.world.character.x)?-1:1}
			if(collisions.bottom==0 && wasOnGround){
				this.x=lastSafeX
				this.y=lastSafeY
				velocityX*=-1
				seesCharacter=false
			}else{
				lastSafeX=this.x
				lastSafeY=this.y
			}
			
									 
		}
	}
}
			