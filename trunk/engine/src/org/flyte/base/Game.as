package flyte.base{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.KeyboardEvent;
	import flyte.events.GameEvent;
	import flyte.world.ScrollWorld;
	/**
	 * The Game class is the top level of a Flyte game. Inside it, you can listen for GameEvents,
	 * load ScrollWorlds, and do everything else involved with building your game. Game can be your
	 * document class, but you might prefer to keep it inside a MovieClip symbol if you don't want
	 * the game to start when the flash file loads.
	 * @author Ian Reynolds
	 * 
	 */
	public class Game extends MovieClip {
		/**
		 * A reference to the actual Game object in use.
		 */
		public static var _root:Game;
		/**
		 * The width of the stage.
		 */
		public static var STAGE_WIDTH:Number;
		/**
		 * The height of the stage.
		 */
		public static var STAGE_HEIGHT:Number;
		/**
		 * A Boolean value that determines whether the engine does collisions for offscreen objects.
		 */
		public static var IGNORE_OUTSIDE:Boolean=true
		/**
		 * Whether the game is paused.
		 */
		public var paused:Boolean=false;
		/**
		 * A sprite that masks the stage so other components of the game can determine whether they are onscreen.
		public var stageTest:Sprite
		 */
		 public var stageTest:Sprite
		private var displayed_world:ScrollWorld;
		private var t:Timer;
		private var m:Sprite;
		protected var level:uint;
		public function Game() {
			_root=this;
			displayed_world=new ScrollWorld();
			addChild(displayed_world);
			addEventListener(GameEvent.GAME_INIT,onGameInit);
			addEventListener(GameEvent.INIT_RESET,onInitReset);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			t=new Timer(10);
			t.addEventListener(TimerEvent.TIMER,onTimer);
			t.start();
			STAGE_WIDTH=this.stage.width;
			STAGE_HEIGHT=this.stage.height;
			stageTest=new Sprite();
			stageTest.graphics.beginFill(0x000000)
			stageTest.graphics.drawRect(0,0,STAGE_WIDTH,STAGE_HEIGHT)
			stageTest.alpha=0.0
			addChild(stageTest)
		}
		private function onInitReset(e:GameEvent):void {
			paused=true;
			world.reset();
			paused=false;
		}
		private function onTimer(e:TimerEvent):void {
			t.stop();
			dispatchEvent(new GameEvent(GameEvent.GAME_INIT));
		}
		public function get world():ScrollWorld {
			return displayed_world;
		}
		public function setWorldByClass(c:Class):void{
			world=new c();
		}
		public function set world(w:ScrollWorld):void {
			if (w!=displayed_world) {
				paused=true
				displayed_world.dispatchEvent(new GameEvent(GameEvent.UNLOAD_WORLD));
				removeChild(displayed_world);
				displayed_world=w;
				addChild(displayed_world);
				GameMovieClip.updateRoot(displayed_world);
				displayed_world.dispatchEvent(new GameEvent(GameEvent.LOAD_WORLD));
				paused=false
			}
		}
		public function onGameInit(e:GameEvent):void {

		}
		private function onEnterFrame(e:Event):void {
			if (! paused) {
				dispatchEvent(new GameEvent(GameEvent.LOOP));
			}
		}/**
		 * Pauses the game.
		 */
		public function pause():void {
			paused=true;
		}
		/**
		 * Resumes the game.
		 */
		public function resume():void {
			paused=false;
		}
	}
}