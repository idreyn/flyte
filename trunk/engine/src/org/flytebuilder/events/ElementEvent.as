package org.flytebuilder.events
{
	import flash.events.*;
	public class ElementEvent extends Event
	{
		public static const SELECT:String="elementSelected";
		public static const DESELECT:String="elementDeselect";
		public var params:Object;
		public function ElementEvent(type:String,params:Object=null)
		{
			super(type);
			this.params=params;
		}
	}
}