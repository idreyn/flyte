package org.flyte.world{

	
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
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
		/**
		 * The distance the game has scrolled on the x-axis.
		 */
		public var scrollX:Number;
		/**
		 * The distance the game has scrolled on the y-axis.
		 */
		public var scrollY:Number;
		/**
		 * The x-value of the left boundary at the edge of the world that the Character cannot move past.
		 */
		public var leftBoundary:Number;
		/**
		 * The x-value of the right boundary at the edge of the world that the Character cannot move past.
		 */
		public var rightBoundary:Number;
		/**
		 * The y-value of the top boundary at the edge of the world that the Character cannot move past.
		 */
		public var topBoundary:Number;
		/**
		 * The y-value of the bottom boundary at the edge of the world that the Character cannot move past.
		 */
		public var bottomBoundary:Number;
		/**
		 * A Rectangle object containing the boundaries of the world.
		 */
		public var bounds:Rectangle;
		/**
		 * The strength of gravity in the game. Keep this at 1 for normal operation.
		 */
		public var gravity:Number=1;
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
		public function ScrollWorld() {
			enum.push(this);
			//Constructor. No, really.
			setWorldOfAllChildMovieClips(this);
			key=new KeyListener  ;
			//Add a couple of listeners for the KeyListener
			key.addEventListener(GameEvent.KEY_DOWN,keyDown);
			key.addEventListener(GameEvent.KEY_UP,keyUp);
			/*Add an event listener that triggers when the superclass GameMovieClip dispatches a GameEvent.ADDED,
			which denotes that the object has been added to the display list and is ready to rock. */
			addEventListener(GameEvent.ADDED,onAdded);
			//Add an event listener that triggers when the Game loads this ScrollWorld
			addEventListener(GameEvent.LOAD_WORLD,onLoadWorld);
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
		public static function get currentIndex():uint {
			return enum.indexOf(Game._root.world);
		}
		private function setWorldOfAllChildMovieClips(g:*):void {
			if (g is GameMovieClip) {
				GameMovieClip(g).myWorld=this;
			}
			for(var i:uint=0; i<g.numChildren; i++) {
				if (g.getChildAt(i) is MovieClip) {
					setWorldOfAllChildMovieClips(g.getChildAt(i));
				}
			}
		}


		private function foundCharacter(e:GameEvent):void {
			camera=new GameCamera();
			addChild(camera);
			camera.follow(character);
		}

		private function onAdded(e:GameEvent):void {
			//This code is called when the ScrollWorld is added to the display list.
			bottomBoundary=7000
			;

		}
		private function onLoopE(e:GameEvent):void {
			if ((Character.current.y>bottomBoundary || Character.current.lives==0) && !Game._root.paused) {
				Character.current.doDie();
			}

		}
		/**
		 * Resets the ScrollWorld.
		 */
		public function reset():void {
			dispatchEvent(new GameEvent(GameEvent.RESET_LEVEL));
		}
		private function onLoadWorld(e:GameEvent):void {
			Game._root.addEventListener(GameEvent.LOOP,onLoopE);
			Character.current=this.character;
			GameObject.setEnum(this);

		}
		protected function keyUp(e:GameEvent):void {


		}
		protected function keyDown(e:GameEvent):void {
				if(e.params.key == 192){
					Game._root.pause();
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