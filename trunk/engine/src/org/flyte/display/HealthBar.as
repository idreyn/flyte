package org.flyte.display{
	import flash.display.*;
	
	import org.flyte.base.*;
	public class HealthBar extends MovieClip{
		private var bar:Sprite
		private var widthO:uint
		private var heightO:uint
		private var colorO:uint
		private var owner:GameObject
		public function HealthBar(width:uint,height:uint,color:uint,sender:GameObject){
			this.widthO=width
			this.heightO=height
			this.colorO=color
			bar=new Sprite();
			this.addChild(bar)
			this.graphics.beginFill(0xCCCCCC)
			bar.graphics.beginFill(color)
			this.graphics.drawRect(0,0,width,height)
			bar.graphics.drawRect(0,0,width,height)
			owner=sender
			
		}
		public function setValue(i:uint):void{
			bar.width=widthO*(i/100)
			
		}
		public function place():void{
			this.y=owner.getBounds(owner).top-(this.height-5)
		}


	}
}
		
		