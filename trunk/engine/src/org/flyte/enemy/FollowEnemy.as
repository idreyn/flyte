package flyte.enemy{
	import flyte.base.*
	import flyte.events.*
	import flyte.collision.*
	public class FollowEnemy extends GameObject{
		protected var seesCharacter:Boolean=true
		public function FollowEnemy(){
			velocityX=1
			addLoopListener(onLoop)
		}
		private function onLoop(e:GameEvent):void{	
			if(seesCharacter){this.movementDirection=this.x>Game._root.world.character.x?-1:1
			this.scaleX=originalScaleX*(this.x>Game._root.world.character.x?-1:1)}
			if(collisions.bottom==0 && wasOnGround){
				this.x=lastSafeX
				this.y=lastSafeY
				movementDirection*=-1
				seesCharacter=false
			}else{
				lastSafeX=this.x
				lastSafeY=this.y
			}
			
									 
		}
	}
}
			