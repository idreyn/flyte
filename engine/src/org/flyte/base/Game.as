
﻿package org.flyte.base{

	import caurina.transitions.Tweener;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flyte.zone.*
	import org.flyte.character.*;
	import org.flyte.events.GameEvent;
	import org.flyte.game.*;
	import org.flyte.hud.*;
	import org.flyte.utils.*;
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
		 * A Boolean value that determines whether the engine does collisions for offscreen objects (Deprecated) Don't use this.
		 */
		public static var IGNORE_OUTSIDE:Boolean=true;
		/**
		 * Whether the game is paused.
		 */
		private var _paused:Boolean=false;
		/**
		 * A sprite that masks the stage so other components of the game can determine whether they are onscreen.
		public var stageTest:Sprite
		 */
		public var stageTest:Sprite;
		
		private var _hud:HUD;
		private var _toLoad:ScrollWorld
		private var displayed_world:ScrollWorld;
		private var t:Timer;
		private var ready:Boolean=false
		private var m:Sprite;
		protected var level:uint;
		
		/**
		 *When the Game constructs, you shouldn't try to load a ScrollWorld until you know for sure it's ready.
		 * Listen for the GameEvent.GAME_INIT event inside of the Game object. 
		 */
		public function Game()
		{
			
			Tracer.out("We're online!");
			_root=this;
			addEventListener(GameEvent.GAME_INIT,onGameInit);
			addEventListener(GameEvent.INIT_RESET,onInitReset);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
			t=new Timer(1000);
			t.addEventListener(TimerEvent.TIMER,onTimer);
			t.start();


		}
		
		public function get paused():Boolean
		{
			return _paused
		}
		private function onAddedToStage(e:Event=null):void
		{
			drawMask()
		}
		private function onInitReset(e:GameEvent):void
		{
			_paused=true;
			Tweener.addTween(stageTest,{alpha:1,time:1,onComplete:maskFadeIn_oC})
			
	
		}
		
		private function maskFadeIn_oC():void
		{
			if(Character.current.lives > 0){
				world.reset()
				Tweener.addTween(stageTest,{alpha:0,time:1,onComplete:maskFadeOut_oC})
			}else{
				dispatchEvent(new GameEvent(GameEvent.GAME_OVER))
			}		
		}
		
		private function maskFadeOut_oC():void
		{
			_paused=false
		}
		
		private function drawMask():Sprite
		{
			if(this.stageTest != null){
				removeChild(stageTest)
			}
			STAGE_WIDTH=stage.width
			STAGE_HEIGHT=stage.height
			stageTest=new Sprite()
			stageTest.graphics.beginFill(0x000000)
			stageTest.graphics.drawRect(0,0,STAGE_WIDTH,STAGE_HEIGHT)
			addChild(stageTest)
			return stageTest
		
		}
		private function onTimer(e:TimerEvent):void
		{
			t.stop();
			dispatchEvent(new GameEvent(GameEvent.GAME_INIT));
		}
		/**
		 * A reference to the current ScrollWorld. BEWARE! Using this inside of GameMovieClips will create
		 * unwanted mess as they may continue to operate even after their ScrollWorld has been unloaded.
		 * For best practice, use the <code>world</code> property of the GameMovieClip instead.
		 * @return A reference to the current game.
		 * @see org.flyte.base.GameMovieClip#world
		 */
		public function get world():ScrollWorld
		{
			return displayed_world;
		}
		/**
		 * Loads a ScrollWorld into the game! 
		 * @param s The ScrollWorld to load.
		 * @param h The HUD object to use. This parameter is optional.
		 * @see org.flyte.hud.HUD
		 */
		public function loadWorld(s:ScrollWorld,h:HUD=null):void
		{
			if(h != null) setHUD(h)
			if(ready){
				setWorld(s)
			}
		}
		
		private function loadPrev(e:GameEvent):void
		{
			trace("loadPrev")
			loadWorld(_toLoad)
		}
		/**
		 * Sets the game HUD to the parameter HUD specified.
		 * @param h The HUD to use
		 * @see org.flyte.hud.HUD
		 */
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
		/**
		 * Basically gives the current ScrollWorld's Character its original amount of lives. Real exciting. 
		 * @see org.flyte.character.Character
		 */
		public function retry():void
		{
			Character.current.lives=Character.current.originLives
			setWorld(displayed_world,true)
		}
		private function clearEnum():void
		{
			
		}
		private function setWorld(w:ScrollWorld,force:Boolean=true):void
		{
			if (w!=displayed_world || force)
			{
				_paused=true;
				if(displayed_world != null){
					displayed_world.dispatchEvent(new GameEvent(GameEvent.UNLOAD_WORLD));
					removeChild(displayed_world);
				}
				try
				{
					removeChild(_hud);
				}
				catch (e:Error)
				{
				}
				clearEnum()
				displayed_world=w;
				addChild(displayed_world);
				try
				{
					addChild(_hud);
				}
				catch (e:Error)
				{
				}
				Checkpoint.reset()
				world.addEventListener(GameEvent.ADDED,reveal)
				addChild(stageTest)
				displayed_world.dispatchEvent(new GameEvent(GameEvent.LOAD_WORLD));
				dispatchEvent(new GameEvent(GameEvent.LOAD))
				_paused=false;
			}
		}
		
		private function reveal(e:GameEvent=null):void
		{
			Tweener.addTween(stageTest,{time:0.3,alpha:0})
		}
		
		public function fadeToPause():void
		{
			Tweener.addTween(addChild(stageTest),{time:1,alpha:1,onComplete:pause})
		}
		private function onGameInit(e:GameEvent):void
		{
			ready=true
		}
		private function onEnterFrame(e:Event):void
		{
			if (! _paused)
			{
				dispatchEvent(new GameEvent(GameEvent.LOOP));
			}
		}/**
		 * Pauses the game.
		 */
		public function pause():void
		{
			_paused=true;
			dispatchEvent(new GameEvent(GameEvent.PAUSE))
		}
		/**
		 * Resumes the game.
		 */
		public function resume():void
		{
			_paused=false;
			dispatchEvent(new GameEvent(GameEvent.RESUME))
		}
		
		public function togglePaused():void
		{
			if(_paused){
				resume()
			}else{
				pause()
			}
		}
			
	}
}