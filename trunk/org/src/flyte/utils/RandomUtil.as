package flyte.utils{
	public class RandomUtil{
		public static function randomInt(min:int,max:int):int{
			return Math.round(Math.random()*max)+min
		}
		public static function randomBoolean():Boolean{
			return Math.random()>0.5
		}
		public static function randomIndex(a:Array):*{
			return a[RandomUtil.randomInt(0,a.length-1)]
		}
	}
}