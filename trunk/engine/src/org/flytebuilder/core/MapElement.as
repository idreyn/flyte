package org.flytebuilder.core
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.filters.GlowFilter;
	import flash.errors.*;
	import org.flytebuilder.events.*;
	public class MapElement extends MovieClip
	{
		public var className:String;
		public var instanceName:String;
		public var _class:Class;
		public var elementWidth:Number;
		public var elementHeight:Number;
		public var color:uint;
		private var _dragged:Boolean=false;
		private var _glow:GlowFilter;
		public function MapElement(inst:String,_class:String,width:Number,height:Number,color:uint)
		{
			this.instanceName=inst;
			this.className=_class;
			try{
			this._class=flash.utils.getDefinitionByName(className) as Class;
			}catch(e:ReferenceError)
			{
			}
			_glow=new GlowFilter();
			_glow.color=0x0066CC;
			_glow.blurX=10;
			_glow.blurY=10;
			this.elementWidth=width;
			this.elementHeight=height;
			this.color=color;
			render();
			addEventListener(MouseEvent.CLICK,onClick);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			addEventListener(ElementEvent.DESELECT,onDeselect);
		}

		private function render():void
		{
			//this.graphics.lineStyle(1,0x000000);
			this.graphics.beginFill(color);
			this.graphics.drawRect(0,0,elementWidth,elementHeight);
			this.alpha=0.6;
		}

		private function onClick(e:MouseEvent):void
		{
			selectThis();
		}

		private function onMouseDown(e:MouseEvent):void
		{
			_dragged=true;
			selectThis();
			this.startDrag();
		}

		private function onMouseOut(e:MouseEvent):void
		{
			if (_dragged)
			{
				//_dragged=false
				//this.stopDrag();
				//deselectThis();
			}
		}

		private function onMouseUp(e:MouseEvent):void
		{
			_dragged=false;
			this.stopDrag();

		}

		private function onDeselect(e:ElementEvent):void
		{
			deselectThis();
		}

		private function selectThis():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.SELECT));
			this.filters=[_glow];
		}

		private function deselectThis():void
		{
			
			this.filters=[];
		}

	}
}