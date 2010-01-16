
﻿package org.flyte.base{

	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.flyte.events.GameEvent;
	import org.flyte.hud.*;
	import org.flyte.io.KeyListener;
	import org.flyte.utils.*;
	import org.flyte.game.*
	import org.flyte.world.ScrollWorld;

	import flash.events.KeyboardEvent;
	import org.flyte.events.GameEvent;
	import org.flyte.world.ScrollWorld;

	/**
	 * The Game class is the top level of a Flyte game. Inside it, you can listen for GameEvents,
	 * load ScrollWorlds, and do everything else involved with building your game. Game can be your
	 * document class, but you might prefer to keep it inside a MovieClip symbol if you don't want
	 * the game to start when the flash file loads.
	 * @author Ian Reynolds
	 * 
	 */
	public class Game extends MovieClip
	{
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
		public static var IGNORE_OUTSIDE:Boolean=true;
		/**
		 * Whether the game is paused.
		 */
		public var paused:Boolean=false;
		/**
		 * A sprite that masks the stage so other components of the game can determine whether they are onscreen.
		public var stageTest:Sprite
		 */
		public var stageTest:Sprite;
		public var _hud:HUD;
		public static var key:KeyListener
		private var displayed_world:ScrollWorld;
		private var t:Timer;
		private var m:Sprite;

		private var _col:Collection
		protected var level:uint;
		public function Game()
		{
			_col=new Collection();
			
			
			Tracer.out("We're online!");
			_root=this;
			displayed_world=new ScrollWorld();
			addChild(displayed_world);
			addEventListener(GameEvent.GAME_INIT,onGameInit);
			addEventListener(GameEvent.INIT_RESET,onInitReset);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			t=new Timer(1000);
			t.addEventListener(TimerEvent.TIMER,onTimer);
			t.start();
			STAGE_WIDTH=640;
			STAGE_HEIGHT=480;
			stageTest=new Sprite();
			stageTest.graphics.beginFill(0x000000);
			stageTest.graphics.drawRect(0,0,STAGE_WIDTH,STAGE_HEIGHT);
			stageTest.alpha=0.0;
			addChild(stageTest);

		}
		
		public static function get collection():Collection
		{
			return Game._root._col
		}
		
		private function onAdded(e:Event=null):void
		{

		}
		private function onInitReset(e:GameEvent):void
		{
			paused=true;
			world.reset();
			paused=false;
		}
		private function onTimer(e:TimerEvent):void
		{
			t.stop();
			dispatchEvent(new GameEvent(GameEvent.GAME_INIT));
		}
		public function get world():ScrollWorld
		{
			return displayed_world;
		}
		public function loadWorld(s:ScrollWorld,h:HUD=null):void
		{
			if(h != null) setHUD(h)
			world=s
		}
		public function setHUD(h:HUD):void
		{
			if (h is HUD)
			{
				this._hud=h
			} else
			{
				throw new Error("Flyte Error: the hud property of a Game object must be a class object representing a class that extends org.flyte.hud.HUD");
			}
		}
		public function set world(w:ScrollWorld):void
		{
			if (w!=displayed_world)
			{
				paused=true;
				displayed_world.dispatchEvent(new GameEvent(GameEvent.UNLOAD_WORLD));
				removeChild(displayed_world);
				try
				{
					removeChild(_hud);
				}
				catch (e:Error)
				{
				}
				Game.collection.reset()
				displayed_world=w;
				addChild(displayed_world);
				try
				{
					addChild(_hud);
				}
				catch (e:Error)
				{
				}
				GameMovieClip.updateRoot(displayed_world);
				Game.key=displayed_world.key
				displayed_world.dispatchEvent(new GameEvent(GameEvent.LOAD_WORLD));
				paused=false;
			}
		}
		public function onGameInit(e:GameEvent):void
		{

		}
		private function onEnterFrame(e:Event):void
		{
			if (! paused)
			{
				dispatchEvent(new GameEvent(GameEvent.LOOP));
			}
		}/**
		 * Pauses the game.
		 */
		public function pause():void
		{
			paused=true;
			dispatchEvent(new GameEvent(GameEvent.PAUSE))
		}
		/**
		 * Resumes the game.
		 */
		public function resume():void
		{
			paused=false;
			dispatchEvent(new GameEvent(GameEvent.RESUME))
		}
	}
}