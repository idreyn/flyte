﻿package org.flyte.world{

	
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.flyte.base.*;
	import org.flyte.character.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.io.*;
	import org.flyte.projectile.*;
	/**
	 * The ScrollWorld class contains an entire level of a game. To create one, you'll need to make a Movieclip
	 * symbol and have it subclass org.flyte.world.ScrollWorld. Then you can add your own Collectibles, Terrain, Platforms, Enemies
	 * and other good stuff to create your level. Then you'll need to add a playable character. Give it the instance
	 * name "character". Then you're free to add powerups, enemies, goals, whatever. They'll all interact nicely.
	 * @author Ian Reynolds
	 *
	 * @see org.flyte.enemy.Enemy
	 * @see org.flyte.world.Platform
	 * @see org.flyte.world.Terrain
	 * @see org.flyte.item.Collectible
	 */
	public class ScrollWorld extends GameMovieClip {
		/* These variables are all public because in addition to subclassing ScrollWorld to modify it, you'll be
		able to mess with the gravity and such from the Timeline, the Flex document you're using, or whatever */

		public var bottomBoundary:Number;
		/**
		 * A Rectangle object containing the boundaries of the world.
		 */
		public var bounds:Rectangle;
		/**
		 * The strength of gravity in the game. Keep this at 1 for normal operation.
		 */
		public var gravity:Number=1.5;
		/**
		 * Whether or not the mouse is down.
		 */
		public var mouseDown:Boolean=false;
		/*The following are a couple of objects that are actual parts of the game. KeyListener key is a
		DisplayObject that dispatches events whenever keypress events happen */
		/**
		 * A reference to the character on the stage in flash that has the instance name "character".
		 * This character is normally accessed with Character.current.
		 * @see org.flyte.character.Character
		 */
		public var character:Character;
		/**
		 * A KeyListener object that listens for keypresses for the game.
		 * @see org.flyte.io.KeyListener
		 */
		public var key:KeyListener;
		/**
		 * The GameCamera object that keeps the focus on a specific object, usually character.
		 * @see org.flyte.display.GameCamera
		 */
		public var camera:GameCamera;
		/**
		 * A static array of all the ScrollWorlds in the flash file.
		 */
		public static var enum:Array=new Array();
		private var dispatching:Boolean=false
		/**
		 * This is the source of GameObject.enum
		 * @see org.flyte.base.GameObject#enum 
		 */
		public var gameObjectEnum:Array
	 	/**
		 * This is the source of Standable.enum
		 * @see org.flyte.collision.Standable#enum 
		 */
		public var standableEnum:Array
		/**
		 * This is the source of GameMovieClip.enum
		 * @see org.flyte.base.GameMovieClip#enum 
		 */
		public var gmcEnum:Array
		public function ScrollWorld() {
			gmcEnum=new Array()
			gameObjectEnum=new Array()
			standableEnum=new Array()
			enum.push(this);
			//Constructor. No, really.
			key=new KeyListener  ;
			//Add a couple of listeners for the KeyListener
			key.addEventListener(GameEvent.KEY_DOWN,keyDown);
			key.addEventListener(GameEvent.KEY_UP,keyUp);
			/*Add an event listener that triggers when the superclass GameMovieClip dispatches a GameEvent.ADDED,
			which denotes that the object has been added to the display list and is ready to rock. */
			addEventListener(GameEvent.ADDED,onAdded);
			//Add an event listener that triggers when the Game loads this ScrollWorld
			addEventListener(GameEvent.LOAD_WORLD,onLoadWorld);
			addEventListener(GameEvent.UNLOAD_WORLD,onUnloadWorld)
			//Mouse listeners
			addEventListener(GameEvent.CHARACTER_FOUND,foundCharacter);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
		}
		
		/**
		 * Returns the index of the current ScrollWorld in the ScrollWorld.enum array.
		 * @return  Returns the index of the current ScrollWorld in the ScrollWorld.enum array.
		 * 
		 */
		 
		 private function onUnloadWorld(e:GameEvent):void
		 {
		 	dispatching=false
		 }
	


		private function foundCharacter(e:GameEvent):void {
			camera=new GameCamera();
			addChild(camera);
			camera.follow(character);
		}

		private function onAdded(e:GameEvent):void {
			//This code is called when the ScrollWorld is added to the display list.
			bottomBoundary=this.getBounds(parent).bottom

		}
		private function onLoopE(e:GameEvent):void {
			if(dispatching && !Game._root.paused){
				dispatchEvent(new GameEvent(GameEvent.LOOP))
			}
			if ((Character.current.y>bottomBoundary || Character.current.lives==0) && !Game._root.paused) {
				Character.current.doDie();
			}
		}
		/**
		 * Resets the ScrollWorld. This normally happens when the Character dies.
		 */
		public function reset():void {
			dispatchEvent(new GameEvent(GameEvent.RESET_LEVEL));
		}
		private function onLoadWorld(e:GameEvent):void {
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
			dispatching=true

		}
		private function keyUp(e:GameEvent):void {


		}
		private function keyDown(e:GameEvent):void {
				if(e.params.key == KeyControls.PAUSE){
					Game._root.togglePaused()
				}

		}
		private function onMouseDown(e:MouseEvent):void {
			mouseDown=true;
		}
		private function onMouseUp(e:MouseEvent):void {
			mouseDown=false;
		}

	}
}