package org.flyte.world{
	import org.flyte.collision.*
	import org.flyte.events.*
	import org.flyte.base.*
	import org.flyte.objective.*
	import org.flyte.item.*
	import org.flyte.character.*
	import org.flyte.world.*
	import org.flyte.display.*
	public class Barrier extends Terrain implements IActivateTargetable{
		public function Barrier(){
			resettable=false
			ActivateTargetable.enum.push(this)
			addActivateTargetableListeners();
			action.mapAction(Action.DEACTIVATE,"destroy",hide)
			action.mapAction(Action.STILL,"still",nothing)
		}
					
		public function addActivateTargetableListeners():void{
			addEventListener(GameEvent.TARGET,target)
		}
		public function activate(e:GameEvent):void{
			visible=true
	
		}
		public function deactivate(e:GameEvent):void{
			target(new GameEvent(GameEvent.TARGET));
		}
		public function target(e:GameEvent):void{
			action.setAction(Action.DEACTIVATE)

		}
		public function hide():void{
			visible=false
		}
	}
}