package
{
	import flash.display.*
	import flash.events.*
	import org.flyte.utils.*
	
	public dynamic class Butterfly extends MovieClip
	{
		private var num:Number
		private var i:int
		private var dir:Number
		public function Butterfly()
		{
			this.scaleX=this.scaleY=0.01
			this.addEventListener(Event.ENTER_FRAME,enterFrame)
			dir=RandomUtil.randomInt(0,360)
		}
		
		private function enterFrame(e:Event):void
		{
			this.x+=Math.sin(dir)*3
			this.y+=Math.cos(dir)*3
			dir+=0.05
			this.scaleX+=0.01
			this.scaleY+=0.01
			this.alpha-=0.05
			if(this.alpha <= 0){
				this.visible=false
				this.removeEventListener(Event.ENTER_FRAME,enterFrame)
				MovieClip(parent).removeChild(this)
			}
		}
			
	}
}