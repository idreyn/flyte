package org.flyte.utils
{
	public class Tracer
	{
		private static function get message():String
		{
			var d:Date=new Date();
			var s:String=(d.hours>12?d.hours-12:d.hours)+":"+(d.minutes<10?"0"+d.minutes:d.minutes)+" "+(d.hours>12?"PM":"AM")
			s+=" "+d.month.toString()+"/"+d.date.toString()+"/"+d.fullYear.toString().slice(2,4);
			return "[Flyte @ "+s+"]"
		}
		public static function out(e:*):void
		{
			trace("[Flyte]",e);
		}
		public static function outWithDate(e:*):void
		{
			trace(message,e)
		}
	}
}