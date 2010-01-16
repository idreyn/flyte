package org.flytebuilder.core
{
	import flash.display.*;
	import flash.events.*;
	import org.flytebuilder.core.*;
	import org.flytebuilder.events.*;
	public class Map extends MovieClip
	{
		public var bkg:MovieClip;
		public var elements:Array;
		public var selected:MapElement;
		public function Map()
		{
			bkg=new MovieClip();
			addChild(bkg);
			bkg.graphics.beginFill(0x0099CC);
			bkg.graphics.drawRect(0,0,800,600);
			trace("constructed")
			
			elements=new Array();
			addEventListener(Event.ADDED,onAdded);
		}

		public function addElement(instanceName:String,className:String,width:Number,height:Number,color:uint):void
		{

			var m:MapElement=new MapElement(instanceName,className,width,height,color);
			elements.push(m);
			addChild(m);
			m.addEventListener(ElementEvent.SELECT,onSelectElement);
		}

		private function onSelectElement(e:ElementEvent):void
		{
			if (selected!=null)
			{
				selected.dispatchEvent(new ElementEvent(ElementEvent.DESELECT));
			}
			selected=e.target as MapElement;
			trace(e.target.instanceName);

		}

		private function onAdded(e:Event):void
		{


			bkg.addEventListener(MouseEvent.CLICK,onClick);
		}

		private function onClick(e:MouseEvent):void
		{
			if (selected!=null)
			{

				selected.dispatchEvent(new ElementEvent(ElementEvent.DESELECT));
			}
			selected=null;
		}
	}
}