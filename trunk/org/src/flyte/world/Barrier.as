package flyte.world{
	import flyte.collision.*
	import flyte.events.*
	import flyte.base.*
	import flyte.objective.*
	import flyte.item.*
	import flyte.character.*
	import flyte.world.*
	import flyte.display.*
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