package org.flyte.utils
{
	import org.flyte.base.*;
	import org.flyte.events.*;
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.objective.*;
	import org.flyte.enemy.*;
	import org.flyte.item.*;
	import org.flyte.zone.*;
	import org.flyte.world.*
	import org.flyte.display.*
	
	import flash.display.*

	/**
	 * The Lazy class consists of an assortment of static functions designed to make you as lazy as possible. Ease of use takes precedence over good OOP.
	 * This ease of use comes with a trade-off, because everyone who reads your code will know that you are LAZY.
	 * @author Ian Reynolds
	 */
	public class Lazy
	{
		/**
		 * Find out if the specified DisplayObject is touching the Character. You ARE lazy, aren't you? Using <listing version="3.0">Collision.hitTestShape()</listing> works fine too.
		 * @param d The DisplayObject to check up on.
		 * @return Whether the Character is in fact touching the specified DisplayObject.
		 * @see org.flyte.collision.Collision#hitTestShape
		 */
		public static function touchesCharacter(d:DisplayObject):Boolean
		{
			return Collision.hitTestShape(Character.current,d);
		}

		/**
		 * Kills the Character.
		 * NOTE: Sad trombone noise removed as of 0.3a.
		 * @see http://www.sadtrombone.com
		 */
		public static function die():void
		{
			Character.current.doDie();
		}

		public static function get character():Character
		{
			return Character.current;
		}

		public static function get game():Game
		{
			return Game._root;
		}
		
		public static function get camera():GameCamera
		{
			return world.camera
		}

		public static function get world():ScrollWorld
		{
			return world;
		}
		/**
		 * Disorient the player by instantly sending the Character to the specified checkpoint.
		 * @param c The Checkpoint to send the character to.
		 */
/*		public static function goToCheckpoint(c:Checkpoint):void
		{
			Character.x=c.x;
			Character.y=c.y;
			c.alert();
		}*/

		/**
		 * The quickest way barring a colon cleanse to bring your character to full health. Or, specify a ridiculously high value and watch the HealthBar throw some errors.
		 * @param i The (optional) value to set the Character's health to. Omit this to restore it to 100, the FDA-approved maximum dosage.
		 */
		public static function maxHealth(i:uint=100):void
		{
			Character.current.health=i;
		}

		/**
		 * Send a GameObject six feet deep with the kill() method. If you don't appreciate my mafia parlance, you can use resurrect() to bring him back up.
		 * @param g The GameObject that'll be swimmin' wit da fishes when me an' Tony are done wit 'em.
		 * @return Ain't you got a brain in dat head of youse, kid? I said it don't return nothin'. We clear?
		 */
		public static function kill(g:GameObject):void
		{
			g.doDie();
		}

		/**
		 * Think he's dead? THINK AGAIN! Use the static resurrect() method to quickly, (and, of course, lazily), bring a GameObject back to life.
		 * @param g The GameObject rising from the grave.
		 */
		public static function resurrect(g:GameObject):void
		{
			g.dead=false;
			g.action.setAction(g.action.DEFAULT);
			g.startListening();
		}

	}
}