package org.flyte.utils
{
	/**
	 * The Tracer class is a nice little utility that outputs to the console with a [Flyte] stamp. 
	 * @author Ian Reynolds
	 * 
	 */
	public class Tracer
	{
		/**
		 * Gives the string the utility will prefix to a string traced with Tracer.outWithDate()
		 * @return A time-stamped message
		 * @see org.flyte.utils.Tracer#outWithDate
		 */
		private static function get message():String
		{
			var d:Date=new Date();
			var s:String=(d.hours>12?d.hours-12:d.hours)+":"+(d.minutes<10?"0"+d.minutes:d.minutes)+" "+(d.hours>12?"PM":"AM")
			s+=" "+d.month.toString()+"/"+d.date.toString()+"/"+d.fullYear.toString().slice(2,4);
			return "[Flyte @ "+s+"]"
		}
		/**
		 * Traces a message with a "[Flyte]" stamp. 
		 * @param e The message to trace.
		 * 
		 */
		public static function out(e:*):void
		{
			trace("[Flyte]",e);
		}
		/**
		 * Traces a message with a dated "[Flyte]" stamp.
		 * @param e The message to trace.
		 * 
		 */
		public static function outWithDate(e:*):void
		{
			trace(message,e)
		}
	}
}