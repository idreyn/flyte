package org.flyte.world{
	import org.flyte.collision.*
	import org.flyte.events.*
	import org.flyte.base.*
	import org.flyte.objective.*
	import org.flyte.item.*
	import org.flyte.character.*
	import org.flyte.world.*
	import org.flyte.display.*
	/**
	 * A Barrier object is basically a piece of Terrain that will "open" and "close" to let things pass through it.
	 * When it receives GameEvent.TARGET it will open. A Barrier's ActionManager requires three name/frame combos:
	 * "still","open", and "close".
	 * @author Ian Reynolds
	 * 
	 */
	public class Barrier extends Terrain{
		public function Barrier(){
			resettable=false
			addActivateTargetableListeners();
			action.mapAction(Action.OPEN,"open",hide)
			action.mapAction(Action.STILL,"still",nothing)
			action.mapAction(Action.CLOSE,"close",nothing,false,false)
		}
					
		private function addActivateTargetableListeners():void{
			addEventListener(GameEvent.TARGET,target)
		}
		/**
		 * Activates the Barrier.
		 * 
		 */
		public function activate():void{
			visible=true
			action.setAction(Action.OPEN)
		}
		/**
		 * Deactivates the Barrier.
		 * 
		 */
		public function deactivate():void{
			action.setAction(Action.OPEN)
		}
		private function target(e:GameEvent):void{
			deactivate()

		}
		private function hide():void{
			visible=false
		}
	}
}