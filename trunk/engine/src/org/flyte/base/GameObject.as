package org.flyte.base
{
	import flash.display.*;
	import flash.geom.*;
	
	import org.flyte.character.*;
	import org.flyte.collision.*;
	import org.flyte.display.*;
	import org.flyte.events.*;
	import org.flyte.game.*;
	import org.flyte.io.*;
	import org.flyte.objective.*;
	import org.flyte.utils.*;
	/**
	 * The GameObject class represents any GameMovieClip that is subject to collisions and gravity.
	 * Unless you plan on deviating from the classic elements of platformer gameplay (enemies, collectibles, hazards, etc),
	 * there should be very little need to call GameObject directly.
	 * 
	 * GameObjects require these name/frame combos: "still","run","die","hit". If you create any more name/frame combos called "attack0","attack1", etc, they will be added to the list of attacks the GameObject randomly uses.
	 * @author Ian Reynolds
	 * @see org.flyte.base.GameMovieClip
	 */
	public dynamic class GameObject extends GameMovieClip
	{
		/**
		 *The miniumum jump height for GameObjects.
		 */
		public static const MIN_JUMP_HEIGHT:Number=15;
		/**
		 *Whether or not the GameObject is attacking. 
		 */
		public var attacking:Boolean=false;
		/**
		 *The health value of the GameObject.
		 */
		public var health:uint=100;
		/**
		 * The number of lives the GameObject has. Most non-character instances
		 * override this to 1.
		 */
		public var lives:uint=3;
		/**
		 * The change in the object's x position from the last frame.
		 */
		public var changeX:Number=0;
		/**
		 * The change in the object's y position from the last loops.
		 */
		public var changeY:Number=0;
		/**
		 * The maximum speed the GameObject can move (run)  on the x axis.
		 */
		public var maxVelocityX:Number=5;
		/**
		 * The maximum speed the GameObject can move (fall) on the y axis.
		 */
		public var maxVelocityY:Number=10;
		/**
		 * Whether or not the GameObject is jumping.
		 */
		public var jumping:Boolean=false;
		/**
		 * The strength of the GameObject's jump
		 */
		public var jumpHeight:Number=10;
		/**
		 * The strength of the bounce the GameObject will make on the next loop.
		 */
		public var bounce:Number=0;
		/**
		 * The strength of the x-displacement the upcoming bounce will make
		 */
		public var bounceX:Number=0;
		/**
		 * Whether or not the character is falling.
		 */
		public var falling:Boolean=true;
		/**
		 * The sensors object for the GameObject that senses collisions.
		 * @see org.flyte.collision.Sensors
		 */
		public var sensors:Sensors;
		/**
		 * Whether the GameObject can move left.
		 */
		public var canMoveLeft:Boolean=true;
		/**
		 * Whether the GameObject can move right.
		 */
		public var canMoveRight:Boolean=true;
		/**
		 * The power of the GameObject's attacks, usually between 1 and 100.
		 * GameObjects generally have a health value of 100, so three attacks
		 * on it with a power of 34 will destroy it.
		 */
		public var attackPower:uint;
		/**
		 * Whether the GameObject is "dead".
		 */
		public var dead:Boolean=false;
		/**
		 * The faction the GameObject belongs to. Characters are assigned 
		 * Faction.GOOD, while AbstractEnemy instances get Faction.BAD. When
		 * attacking another GameObject, it checks its target's faction property
		 * to make sure it's not a friend.
		 */
		public var faction:String;
		/**
		 * Whether or not the GameObject is destroyable.
		 */
		public var destroyable:Boolean=true;
		/**
		 * Whether the GameObject will move on the x-axis.
		 */
		public var moves:Boolean=true;
		/**
		 * Whether the GameObject has just been hurt.
		 */
		public var hurting:Boolean=false;
		/**
		 * Whether the GameObject should display a HealthBar object.
		 */
		public var showHealthBar:Boolean=true
		/**
		 * The value the GameObject will use as a damping for its jump velocity once the jump
		 * key has been released. Higher values == higher jump. 
		 */
		public var jumpDamping:Number=0.8
		/**
		 * The value the GameObject will use as a damping for its jump velocity before the jump
		 * key has been released. Values greater than or equal to 1 == flying! 
		 */		
		public var jumpDampingHold:Number=0.83
		/**
		 * How much the GameObject will push another one when attacking it.
		 */
		public var pushPower:Number=1.5
		/**
		 * The collisions object has four uint properties (left,right,top,bottom) that indicate how many collisions it currently
		 * has against that sensor. 
		 */		
		public var collisions:Object;
		/**
		 * The number of lives the GameObject started with 
		 */		
		public var originLives:uint=lives;
		private var jump:Number=0;
		private var _bounds:Rectangle
		protected var lastX:Number=0;
		protected var lastY:Number=0;
		protected var possibleAttacks:Array;
		protected var originalScaleX:Number;
		protected var lastSafeX:Number;
		protected var lastSafeY:Number;
		protected var wasOnGround:Boolean;
		protected var currentAnimation:MovieClip=new MovieClip();
		protected var currentAction:String;
		protected var dying:Boolean=false;
		protected var healthBar:HealthBar;
		protected var friction:uint=0;
		protected var baseJumpHeight:uint=jumpHeight
		private var hasAttackTarget:Boolean=false;
		private var attackElapsed:uint=0;
		private var invalidateAnimation:Boolean=false;
		private var invalidateRunning:Boolean=false;
		private var hbOriginX:Number;
		private var hbOriginY:Number;
		private var flashDuration:uint
		private var flashElapsed:uint
		private var flashUpdate:uint
		private var tryDoDie:Boolean=false;
		private var pushVelocity:Number=0;
		protected var jumpReleased:Boolean=false
		/**
		 * Looks like a constructor to me! 
		 * 
		 */		
		public function GameObject()
		{
			stop();
			this.faction=FactionManager.NEUTRAL;
			lastSafeX=this.x;
			lastSafeY=this.y;
			originalScaleX=this.scaleX;
			collisions=new Object();
			collisions.right=0;
			collisions.left=0;
			collisions.top=0;
			collisions.bottom=0;
			sensors=new Sensors(this);
			addChild(sensors);
			sensors.alpha=0
			lastX=this.x;
			lastY=this.y;
			addEventListener(GameEvent.ADDED,onAdded);
			addEventListener(GameEvent.COLLISION,registerCollision);
			addEventListener(GameEvent.END_COLLISION,registerCollisionEnd);
			addEventListener(GameEvent.JUMP,do_jump);
			addEventListener(GameEvent.HIT,onHit);
			addEventListener(GameEvent.LOAD_WORLD,onLoadWorld)
			healthBar=new HealthBar(25/scaleX,5/scaleX,0x009932,this);
			this.addChild(healthBar);
			healthBar.visible=showHealthBar && destroyable;
			this.blendMode=BlendMode.LAYER;
		}
		
		private function onLoadWorld(e:GameEvent):void
		{
			dispatchGameEvent(GameEvent.HEALTH)
		}
		/**
		 *The direction the GameObject is moving as an integer: -1 for left, 0 for still, 1 for right.
		 * @return 
		 * 
		 */
		public function get movementDirection():int
		{
			return velocityX==0?0:velocityX>0?1:-1;
		}
		
		/**
		 * The enum object for GameObjects; actually a reference to Game._root.world.gameObjectEnum (shhh!) 
		 * @return All the GameObjects in the current world
		 */
		public static function get enum():Array
		{
			return Game._root.world.gameObjectEnum
		}
		protected override function mapActions():void
		{
			getPossibleAttacks();
			action.mapAction(Action.STILL,"still",nothing);
			action.mapAction(Action.RUN,"run",nothing,true,true);
			action.mapAction(Action.ATTACK,possibleAttacks,onAttackComplete,false,true);
			action.mapAction(Action.DIE,"die",onDie,false,false);
			action.mapAction(Action.HIT,"hit",nothing);
			action.setAction(Action.STILL);
			action.DEFAULT=Action.STILL;
			action.addEventListener(GameEvent.ACTION_COMPLETE,onActionComplete);
			_bounds=this.action.body.getBounds(this)

		}
		private function onActionComplete(e:GameEvent):void{
		}
		protected function getPossibleAttacks():void
		{
			possibleAttacks=new Array();
			for(var i:uint=0; i<currentLabels.length; i++)
			{
				var t:String=currentLabels[i].name;
				if (t.slice(0,6)=="attack")
				{
					possibleAttacks.push(currentLabels[i].name);
				}
			}
		}
		/**
		 * Makes the GameObject destroyable.
		 */
		public function makeDestroyable(t:Boolean=true):void
		{
			destroyable=t;
			healthBar.visible=showHealthBar
		}
		/**
		 * Makes the GameObject non-destroyable.
		 */
		public function makeNonDestroyable():void
		{
			healthBar.visible=destroyable=false;
		}
		private function onDie():void
		{
			dispatchEvent(new GameEvent(GameEvent.DIE))
			this.velocityX=0;
			dead=true;
			stopListening();
			this.health=100;
		}


		/**
		 * Kills the GameObject.
		 */
		public function doDie():void
		{
			if (! action.actionInProgress(Action.DIE))
			{
				action.setAction(Action.DIE);
		
			}

		}

		protected function attack():void
		{
			if (! action.actionInProgress(Action.ATTACK)&&! dead)
			{
				addLoopListener(attackLoop);
				action.setAction(Action.ATTACK);
				if (this is Character)
				{
					this.velocityX+=(velocityX>0)?8:-8
					
				}
			}
		}
		private function attackLoop(e:GameEvent):void
		{
			if(!hasAttackTarget){
				findAttackTarget(stage.frameRate-attackElapsed);
				hasAttackTarget=true;
			}
			attackElapsed++
		}
		private function onAttackComplete():void
		{
			dispatchEvent(new GameEvent(GameEvent.ATTACK_COMPLETE));
			hasAttackTarget=false
			attackElapsed=0
		}
		private function findAttackTarget(s:uint):Boolean
		{
			var f:Boolean=false;
			for(var i:uint=0; i<GameObject.enum.length; i++)
			{
				var t:GameObject=GameObject.enum[i];
				if (Collision.hitTestShape(this,t)&&t!=this&&t.faction!=this.faction&&!t.dead && !t.hurting && !this.hurting)
				{
					t.dispatchEvent(new GameEvent(GameEvent.HIT,{sender:this,damage:this.attackPower,velocity:this.velocityX,pushPower:this.pushPower}));
					f=true;
					break;
				}
			}
			return f;
		}
		protected function do_jump(e:GameEvent):void
		{
			if (e.params.bounce>0)
			{
				tryJump(e.params.bounce,false);
			}
		}
		private function onHit(e:GameEvent):void
		{
			action.setAction(Action.HIT)
			if (destroyable)
			{
				if (health-e.params.damage>0)
				{
					health-=e.params.damage;
					healthBar.setValue(health);
					push(e.params.velocity*e.params.pushPower)
					
					
					
					hurting=true;
					flashThis(25,2);
					dispatchGameEvent(GameEvent.HEALTH)
				} else
				{

					doDie();
				}
			}
		}
		private function onResetLevelE(e:GameEvent):void
		{
			this.rotation=0
			this.collisions.left=0;
			this.collisions.right=0;
			this.collisions.top=0;
			this.collisions.bottom=0;
			this.jumping=false;
			this.jumpReleased=true;
			this.invalidateRunning=false;
			this.invalidateAction=false;
			this.dying=false;
			this.running=false;
			this.flying=false;
			this.falling=true;
			this.health=100;
			dispatchGameEvent(GameEvent.HEALTH)
			healthBar.setValue(health);
			action.active=false;
			this.attacking=false;
			this.hurting=false
			this.tryDoDie=false;
			this.jumpHeight=this.baseJumpHeight
		}
		protected function registerCollision(e:GameEvent):void
		{
			switch (e.params.type)
			{
				case CollisionType.BOTTOM :
					falling=false;
					jumping=false;
					jumpReleased=true;
					wasOnGround=true;
					collisions.bottom++;
					if (e.params.jumpHeight>0)
					{
						this.jumpHeight=Math.max(this.jumpHeight+e.params.jumpHeight,MIN_JUMP_HEIGHT);
					}
					this.velocityY=0;
					this.bounce=e.params.bounce;
					this.bounceX=e.params.bounceX;
					this.friction=e.params.friction;
					break;
				case CollisionType.TOP :
					collisions.top++;
					jumping=false;
					falling=true;
					velocityY*=(5+e.params.rebound);
					break;
				case CollisionType.RIGHT :
					collisions.right++;
					canMoveRight=false;
					break;
				case CollisionType.LEFT :
					collisions.left++;
					canMoveLeft=false;
					break;
			}
		}
		protected function registerCollisionEnd(e:GameEvent):void
		{
			switch (e.params.type)
			{
				case CollisionType.BOTTOM :
					if (! dying)
					{
						if (this.collisions.bottom>0)
						{
							this.collisions.bottom--;
						}
						if (collisions.bottom==0)
						{
							falling=true;
							jumpHeight=MIN_JUMP_HEIGHT;
							bounceX=0;
						}
					}
					break;


				case CollisionType.TOP :
					collisions.top--;
					break;


				case CollisionType.RIGHT :
					collisions.right--;
					if (collisions.right==0)
					{
						canMoveRight=true;
					}
					break;
				case CollisionType.LEFT :
					collisions.left--
					collisions.left=Math.max(collisions.left,0)
					if (collisions.left==0)
					{
						canMoveLeft=true;
					}
					break;


			}
		}
		protected function customActions():void
		{
			//Empty, to be overridden.
		}
		private function onLoop(e:GameEvent):void
		{
			pushVelocity*=.95
			customActions();
			healthBar.scaleX=movementDirection==0?1:movementDirection;
		

			if ((movementDirection==1 && canMoveRight) || (movementDirection==-1 && canMoveLeft))
			{

				this.x+=(velocityX+pushVelocity)
				this.y+=Math.abs((velocityX+pushVelocity)*Math.sin(radians(rotation)))

			}
			if (! falling&&bounce>0)
			{
				tryJump(bounce);
				velocityX=bounceX;
				
			}
			if (jumping)
			{
				this.y-=jump;
				this.rotation-=((this.rotation)/5)*2;
				if(!jumpReleased && !world.key.isDown(KeyControls.JUMP)){
					jumpReleased=true
				}
				jump*=(jumpReleased)?jumpDamping:jumpDampingHold;
				if (jump<1)
				{
					jumping=false;
					falling=true;
				}
			} else
			{
				if(this is Character && Character(this).stuckToTerrain){
					return void;
				}
				if (falling)
				{
					this.y+=velocityY
					this.velocityY+=world.gravity;
					
				}
			}
		}
		private function onAdded(e:GameEvent):void
		{
			enum.push(this)
			addLoopListener(onLoop)
			world.addEventListener(GameEvent.LOOP,checkChange);
			world.addEventListener(GameEvent.RESET_LEVEL,onResetLevelE);
			getPossibleAttacks();
			dispatchGameEvent(GameEvent.HEALTH)
			healthBar.place()
		}
		/**
		 * Causes the GameObject to flash to indicate it's been hurt. Nice old-school touch there. 
		 * @param duration How many frames to flash
		 * @param update How long the flashes should be
		 * 
		 */		
		public function flashThis(duration:uint,update:uint):void
		{
			flashDuration=duration;
			flashUpdate=update;
			addLoopListener(onLoopFlash);
		}
		/**
		 * The GameObject.enum array is a collection of all GameObjects in a ScrollWorld.
		 * This method populates the GameObject.enum array with all GameObjects from the 
		 * ScrollWorld specified.
		 * @param w The Scrollworld whose GameObjects will populate GameObject.enum
		 * 
		 */
		 
		protected function checkChange(e:GameEvent):void
		{
			changeX=this.x-lastX;
			changeY=this.y-lastY;
			lastX=this.x;
			lastY=this.y;
		}

		protected function tryJump(j:Number,manual:Boolean=true):void
		{
			if (collisions.top==0)
			{
				jumpReleased=false;
				wasOnGround=false;
				velocityY=0;
				jump=j;
				jumping=true;
			}
		}
		private function onLoopFlash(e:GameEvent):void
		{
			if(flashElapsed % flashUpdate == 0)
			{
				this.alpha=(alpha==0.5)?1:0.5
			}
			if(flashElapsed >= flashDuration)
			{
				world.removeEventListener(GameEvent.LOOP,onLoopFlash);
				this.alpha=1;
				flashElapsed=0;
				hurting=false;
			}
			flashElapsed++
		}
		
		public function get bounds():Rectangle
		{
			return _bounds//this.action.body.getBounds(this)
		}
			
		/**
		 * Gives the GameObject a little velocityX boost.
		 * @param i The strength of the push
		 * 
		 */		
		public function push(i:Number):void
		{
			pushVelocity=i;
		}


	}
}