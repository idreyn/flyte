package flyte.display{
	public dynamic class Action{
		public static const STILL:String="actionStill"
		public static const RUN:String="actionRun"
		public static const ATTACK:String="actionAttack"
		public static const HIT:String="actionHit"
		public static const DIE:String="actionDie"
		public static const JUMP:String="actionJump"
		public static const CLIMB:String="actionClimb"
		public static const FLIP:String="actionFlip"
		public static const CHANGE_DIRECTION:String="actionChangeDirection"
		public static const DESTROY:String="actionDestroy"
		public static const DEACTIVATE:String="actionDeactivate"
		public static const ACTIVATE:String="actionActivate"
		public static const NORMAL:String="actionNormal"
		public var loops:Boolean
		public var frame:*
		public var name:String
		public var active:Boolean
		public var resetOnComplete:Boolean
		public var actionOnComplete:Function
		public var hasAnimation:*
		public function Action(name:String,frame:*,action:Function,hasAnimation:*,loops:Boolean=false,resetOnComplete:Boolean=true){
			this.name=name
			this.frame=frame
			this.loops=loops
			this.resetOnComplete=resetOnComplete
			this.actionOnComplete=action
			this.hasAnimation=hasAnimation
		}
		public function start():void{
			active=true
		}
		public function stop():void{
			active=false
		}
	}
}