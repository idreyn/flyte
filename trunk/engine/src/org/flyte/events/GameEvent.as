package org.flyte.events{
	import flash.events.Event;
	/**
	 * The GameEvent class is a set of events that can be dispatched unique to org.flyte.
	 */
	public class GameEvent extends Event{
		/**
		 * The event dispatched once per Event.ENTER_FRAME if the game is not paused.
		 * @see org.flyte.base.Game
		 */
		public static const LOOP:String="gameEventLoop"
		/**
		 * The event dispatched by a KeyListener when a key is pressed.
		 * @see org.flyte.io.KeyListener
		 */
		public static const KEY_DOWN:String="gameKeyDown"
		/**
		 * The event dispatched by a KeyListener when a key is released.
		 * @see org.flyte.io.KeyListener
		 */
		public static const KEY_UP:String="gameKeyUp"
		/**
		 * The event dispatched by a GameMovieClip when it is added to the display list
		 * and initialized.
		 * @see org.flyte.base.GameMovieClip
		 */
		public static const ADDED:String="gameAdded"
		/**
		 * The event dispatched by a ScrollWorld when it determines that it contains a Character object.
		 * It's worth noting that the Character object actually does this by calling Game._root.world.
		 * @see org.flyte.world.ScrollWorld
		 * @see org.flyte.character.Character
		 */
		public static const CHARACTER_FOUND:String="gameFoundCharacter"
		/**
		 * Dispatched by an instance of Standable to a GameObject when they collide.
		 * @see org.flyte.collision.Standable
		 * @see org.flyte.base.GameObject
		 */
		public static const COLLISION:String="gameCollision"
		/**
		 * Dispatched by an instance of Standable to a GameObject when their collision ends.
		 * @see org.flyte.collision.Standable
		 * @see org.flyte.base.GameObject
		 */
		public static const END_COLLISION:String="gameEndCollision"
		/**
		 * Dispatched by a ScrollWorld when it is loaded.
		 */
		public static const LOAD_WORLD:String="gameLoadWorld"
		/**
		 * Dispatched by a ScrollWorld when it is unloaded.
		 */
		public static const UNLOAD_WORLD:String="gameUnloadWorld"
		/**
		 * Dispatched when the Game is ready to start. To execute timeline code at this point, listen for GameEvent.GAME_INIT.
		 */
		public static const GAME_INIT:String="gameInit"
		/**
		 * Dispatched by a Floor object when the character touches it.
		 * @see org.flyte.world.Floor
		 * @see org.flyte.character.Character
		 */
		public static const ENTER_PLATFORM:String="gameEnterPlatform"
		/**
		 * Dispatched by a Floor object when the character leaves it.
		 * @see org.flyte.world.Floor
		 * @see org.flyte.character.Character
		 */
		public static const LEAVE_PLATFORM:String="gameLeavePlatform"
		/**
		 * Dispatched by a GameObject when it gains health.
		 * @see org.flyte.base.GameObject
		 */
		public static const GAIN_HEALTH:String="gameGainHealth"
		/**
		 * Dispatched to a GameObject to cause it to lose health.
		 * Example: <listing version="3.0">aGameObject.dispatchEvent(new GameEvent(GameEvent.HIT,{damage:value}))</listing>
		 * @see org.flyte.base.GameObject
		 */
		public static const HIT:String="gameLoseHealth"
		/**
		 * Dispatched by a Game object when it pauses execution of the game.
		 * @see org.flyte.base.Game
		 */
		public static const PAUSE:String="gamePause"
		/**
		 * Dispatched by a Game object when it resumes execution of the game.
		 * @see org.flyte.base.Game
		 */
		public static const RESUME:String="gameResume"
		/**
		 * Dispatched by a ScrollWorld to reset everything in it.
		 */
		public static const RESET_LEVEL:String="gameResetLevel"
		/** 
		 * Dispatched to a Game to fade to black then reset the current level.
		 */
		public static const INIT_RESET:String="gameInitReset"
		/**
		 * Dispatched to a GameObject to cause it to jump.
		 * Example: <listing version="3.0">aGameObject.dispatchEvent(new GameEvent(GameEvent.JUMP,{jump:value}))</listing>
		 */		
		public static const JUMP:String="gameJump"
		/**
		 * Dispatched by a SelfControlledGameObject when after it looks for a RestrictionZone
		 * (RestrictionZone not yet implemented)
		 * @see org.flyte.motion.SelfControlledGameObject
		 */
		public static const DETERMINE_RESTRICTION:String="gameDetermineRestriction"
		/**
		 * Dispatched by a GameObject when it kicks the bucket.
		 * @see org.flyte.base.GameObject
		 */
		public static const DIE:String="gameDie"
		/**
		 * Dispatched by an object to let other object know it has been destroyed
		 */
		public static const DESTROY:String="gameDestroy"
		/**
		 * Dispatched when the game ends
		 */
		public static const GAME_OVER:String="gameOver"
		/**
		 * Dispatched by the action:ActionManager property of a GameMovieClip when an action finishes
		 * @see org.flyte.display.ActionManager
		 * @see org.flyte.base.GameMovieClip 
		 */
		public static const ACTION_COMPLETE:String="gameActionComplete"
		/** Dispatched by a Collectible when it is collected.
		 * @see org.flyte.item.Collectible
		 */
		public static const COLLECTED:String="gameCollected"
		/**
		 * Dispatched to activate an object that implements IActivateTargetable.
		 * @see org.flyte.objective.IActivateTargetable
		 */
		 public static const ACTIVATE:String="gameActivate"
		/**
		 * Dispatched to deactivate an object that implements IActivateTargetable.
		 * @see org.flyte.objective.IActivateTargetable
		 */
		 public static const DEACTIVATE:String="gameDeactivate"
		/**
		 * Dispatched by an AccessItem when it finds a target
		 * @see org.flyte.item.AccessItem
		 */
		public static const TARGET:String="gameTarget"
		/**
		 * The params object holds parameters passed through the GameEvent constructor
		*/
		public static const ENTER:String="gameEnter"
		public static const CHARACTER_ENTER:String="gameCharacterEnter"
		public static const EXIT:String="gameExit"
		public static const CHARACTER_EXIT:String="gameCharacterExit"
		public static const ATTACK_COMPLETE:String="gameAttackComplete"
		public var params:Object
		public function GameEvent(type:String,params:Object=null){
			super(type)
			this.params=params
		}
	}
}