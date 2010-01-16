package org.flyte.enemy{
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.events.*;
	public class FollowEnemy extends GameObject{
		protected var seesCharacter:Boolean=true
		public var visionRange:Number=300;
		public function FollowEnemy(){
			velocityX=1
			addLoopListener(onLoop)
		}
		private function onLoop(e:GameEvent):void{	
			if(seesCharacter){this.velocityX=(Math.abs(this.x-Character.current.x)>this.visionRange)?0:(this.x > Game._root.world.character.x)?-1:1}
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
			