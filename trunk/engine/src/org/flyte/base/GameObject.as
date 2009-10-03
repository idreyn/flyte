package flyte.base
{
	import flash.display.*;
	import flyte.character.*;
	import flyte.collision.*;
	import flyte.display.*;
	import flyte.events.*;
	import flyte.game.*;
	import flyte.objective.*;
	import flyte.utils.*;
	import flyte.world.ScrollWorld;
	/**
	 * The GameObject class represents any GameMovieClip that is subject to collisions and gravity.
	 * Unless you plan on deviating from the classic elements of platformer gameplay (enemies, collectibles, hazards, etc),
	 * there should be very little need to call GameObject directly.
	 * @author Ian Reynolds
	 * @see flyte.base.GameMovieClip
	 */
	public dynamic class GameObject extends GameMovieClip
	{
		/**
		 *The miniumum jump height for GameObjects.
		 */
		public static const MIN_JUMP_HEIGHT=15;
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
		 * @see flyte.collision.Sensors
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
		protected var collisions:Object;
		protected var jump:Number=0;
		protected var lastX:Number=0;
		protected var lastY:Number=0;
		protected var originLives:uint=lives;
		protected var possibleAttacks:Array;
		protected var originalScaleX;
		protected var lastSafeX:Number;
		protected var lastSafeY:Number;
		protected var wasOnGround:Boolean;
		protected var currentAnimation:MovieClip=new MovieClip();
		protected var currentAction:String;
		protected var dying:Boolean=false;
		protected var healthBar:HealthBar;
		protected var friction:uint=0;
		private var invalidateAnimation:Boolean=false;
		private var invalidateRunning:Boolean=false;
		private var hbOriginX:Number;
		private var hbOriginY:Number;
		private var flashDuration:uint
		private var flashElapsed:uint
		private var flashUpdate:uint
		private var tryDoDie:Boolean=false;
		public static var enum:Array=new Array();
		private static var tEnum:Array=new Array();
		public function GameObject()
		{
			stop();
			this.faction=FactionManager.NEUTRAL;
			lastSafeX=this.x;
			lastSafeY=this.y;
			originalScaleX=this.scaleX;
			tEnum.push(this);
			collisions=new Object();
			collisions.right=0;
			collisions.left=0;
			collisions.top=0;
			collisions.bottom=0;
			sensors=new Sensors(this);
			addChild(sensors);
			lastX=this.x;
			lastY=this.y;
			addEventListener(GameEvent.ADDED,onAdded);
			addEventListener(GameEvent.COLLISION,registerCollision);
			addEventListener(GameEvent.END_COLLISION,registerCollisionEnd);
			addEventListener(GameEvent.JUMP,do_jump);
			addEventListener(GameEvent.HIT,onHit);
			healthBar=new HealthBar(25/scaleX,5/scaleX,0x009932,this);
			this.addChild(healthBar);
			healthBar.visible=destroyable;
			this.blendMode=BlendMode.LAYER;
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
		protected override function mapActions():void
		{
			getPossibleAttacks();
			action.mapAction(Action.STILL,"still",nothing);
			action.mapAction(Action.RUN,"run",nothing,true,true);
			action.mapAction(Action.ATTACK,possibleAttacks,onAttackComplete,false,true);
			action.mapAction(Action.DIE,"die",onDie,false,false);
			action.setAction(Action.STILL);
			action.DEFAULT=Action.STILL;
			action.addEventListener(GameEvent.ACTION_COMPLETE,onActionComplete);

		}
		private function onActionComplete(e:GameEvent):void{
			//trace(e.params.action);
		}
		protected function getPossibleAttacks():void
		{
			possibleAttacks=new Array();
			for (var i=0; i<currentLabels.length; i++)
			{
				var t=currentLabels[i].name;
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
			healthBar.visible=destroyable=t;
		}
		/**
		 * Makes the GameObject non-destroyable.
		 */
		public function makeNonDestroyable():void
		{
			healthBar.visible=destroyable=false;
		}
		protected function onDie():void
		{
			trace("onDie")
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
				findAttackTarget();
				action.setAction(Action.ATTACK);
				if (this is Character)
				{
					this.velocityX*=10;
				}
			}
		}
		protected function onAttackComplete():void
		{

		}
		private function findAttackTarget():Boolean
		{
			var f=false;
			for (var i=0; i<GameObject.enum.length; i++)
			{
				var t=GameObject.enum[i];
				if (Collision.hitTestShape(this,t)&&t!=this&&t.faction!=this.faction&&!t.dead)
				{
					t.dispatchEvent(new GameEvent(GameEvent.HIT,{sender:this,damage:this.attackPower,velocity:(this.x-t.x)/25}));
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
			if (destroyable)
			{
				if (health-e.params.damage>0)
				{
					health-=e.params.damage;
					healthBar.setValue(health);
					velocityX-=e.params.velocity
					flashThis(25,2);
				} else
				{

					doDie();
				}
			}
		}
		private function onResetLevelE(e:GameEvent):void
		{
			this.collisions.left=0;
			this.collisions.right=0;
			this.collisions.top=0;
			this.collisions.bottom=0;
			this.jumping=false;
			this.invalidateRunning=false;
			this.invalidateAction=false;
			this.dying=false;
			this.running=false;
			this.flying=false;
			this.falling=true;
			this.health=100;
			healthBar.setValue(health);
			healthBar.place();
			action.active=false;
			this.attacking=false;
			this.tryDoDie=false;
		}
		protected function registerCollision(e:GameEvent):void
		{
			switch (e.params.type)
			{
				case CollisionType.BOTTOM :
					falling=false;
					jumping=false;
					wasOnGround=true;
					collisions.bottom++;
					if (e.params.jumpHeight>0)
					{
						this.jumpHeight=Math.max(e.params.jumpHeight,MIN_JUMP_HEIGHT);
					}
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
					collisions.left--;
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
			customActions();
			healthBar.scaleX=sensors.scaleX=movementDirection==0?1:movementDirection;
		
			if (movementDirection!=0)
			{
				this.scaleX=movementDirection*originalScaleX;
			}
			if ((movementDirection==1 && canMoveRight) || (movementDirection==-1 && canMoveLeft))
			{

				this.x+=velocityX;

			}
			if (! falling&&bounce>0)
			{
				tryJump(bounce);
				velocityX=bounceX;
			}
			if (jumping)
			{
				this.y-=jump;
				this.rotation-=this.rotation/5;
				jump*=0.85;
				if (jump<1)
				{
					jumping=false;
					falling=true;
				}
			} else
			{
				if (falling)
				{
					this.velocityY+=Game._root.world.gravity;
					y+=velocityY;
				}
			}
		}
		private function onAdded(e:GameEvent):void
		{
			addLoopListener(onLoop)
			Game._root.addEventListener(GameEvent.LOOP,checkChange);
			Game._root.world.addEventListener(GameEvent.RESET_LEVEL,onResetLevelE);
			getPossibleAttacks();
			//healthBar.place();
		}
		public function flashThis(duration:uint,update:uint)
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
		public static function setEnum(w:ScrollWorld):void
		{
			enum.length=0;
			for (var i=0; i<tEnum.length; i++)
			{
				if (tEnum[i].myWorld==w)
				{
					enum.push(tEnum[i]);
				}
			}
		}
		protected function checkChange(e:GameEvent)
		{
			changeX=this.x-lastX;
			changeY=this.y-lastY;
			lastX=this.x;
			lastY=this.y;
		}

		protected function tryJump(j:Number,manual:Boolean=true)
		{
			if (collisions.top==0)
			{
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
				Game._root.removeEventListener(GameEvent.LOOP,onLoopFlash);
				this.alpha=1;
				flashElapsed=0;
			}
			flashElapsed++
		}


	}
}