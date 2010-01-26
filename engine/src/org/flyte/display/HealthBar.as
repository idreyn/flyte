package org.flyte.display{
	import flash.display.*;
	
	import org.flyte.base.*;
	/**
	 * A HealthBar object is a little thing that hangs above GameObjects showing their health value.
	 * If you don't like it, set the showHealthBar property of the GameObject to false.
	 * @author Ian Reynolds
	 * @see org.flyte.base.GameObject#showHealthBar
	 */
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
		/**
		 * Sets the value the health bar displays, between 1 and 100, typically health. 
		 * @param i
		 * 
		 */		
		public function setValue(i:uint):void{
			bar.width=widthO*(i/100)
			
		}
		/**
		 * Sets the HealthBar on top of its owner. If the owner has any weird pieces sticking out,
		 * this will not look like correct placement. Feel free to make corrections. 
		 * 
		 */		
		public function place():void{
			this.y=owner.getBounds(owner).top-(this.height-5)
		}


	}
}
		
		