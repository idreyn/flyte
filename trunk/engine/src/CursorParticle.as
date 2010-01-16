package
{
	import flash.events.*
	import flash.display.*
	import flash.filters.*
	
	public dynamic class CursorParticle extends MovieClip
	{
		private var dir:Number
		private var p:MovieClip
		public function CursorParticle(x:Number,y:Number,p:MovieClip){
			this.p=p
			this.x=x
			this.y=y
			addEventListener(Event.ENTER_FRAME,enterFrame)
		}
		
		private function enterFrame(e:Event):void
		{
			this.dir=Math.atan2(p.mouseY,p.mouseX)
			var xd=this.x-p.mouseX
			var yd=this.y-p.mouseY
			var dist:Number=Math.sqrt(Math.pow(xd,2)+Math.pow(yd,2))/5
			this.x+=dist*Math.sin(dir)
			this.y+=dist*Math.sin(dir)
		}
	}
}