package flyte.objective{
	import flyte.collision.*
	import flyte.event.*
	import flyte.base.*
	import flyte.events.*
	public class Checkpoint extends GameMovieClip{
		public static var currentX:Number
		public static var currentY:Number
		public static var enum:Array=new Array();
		public static var current:uint=0
		public var number:uint
		public function Checkpoint(){
			resettable=false
			number=enum.length
			enum.push(this)
			addEventListener(Event.ADDED,onAdded)
		}
		private function onAdded(e:GameEvent):void{
			addLoopListener(loop)
		}
		private function loop(e:GameEvent):void{
			if(Collision.hitTestShape(this,Character.current) && !current==number){
				current=number
				currentX=this.x
				currentY=this.y
			}
		}
		public function reset():void{
			action.setAction(action.DEFAULT)
		}
		public static function setCheckpoint(c:Checkpoint):void{
			current=c.number
			currentX=c.x
			currentY=c.y
		}
	}
}
			
			