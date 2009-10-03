package flyte.game{
	public dynamic class FactionManager{
		/*The whole point of the FactionManager class is to make sure good guys only attack bad guys and vice-versa.
		Each GameObject has a faction property, and depending on what that is set to, GameObjects won't be able to
		find each other with their findAttackTarget() method. This allows for red-versus-blue-versus-green
		three-sided epic battles where the enemies won't accidentially knock each other down. Kapeesh?*/
		public static const GOOD:String="daGoodGuyz"
		public static const BAD:String="daBadGuyz"
		public static const NEUTRAL:String="daNeutralGuyz"
	}
}