package org.flyte.motion
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.*
	import org.flyte.base.GameMovieClip;
	import org.flyte.events.GameEvent;
	;
	
	/**
	 * A highly experimental class that you should ignore completely. But it will be awesome when it's done. 
	 * @author Ian Reynolds
	 * 
	 */
	public class MotionManager extends EventDispatcher
	{
		private var _has:Boolean=false
		private var targets:Array
		private var _active:Boolean=false
		private var suffix:String="target"
		private var _obj:GameMovieClip
		private var _tweenIndex:uint=1
		public var tweenTime:Number
		public var speed:Number=1
		public function MotionManager(t:GameMovieClip,a:Boolean=false,target:Array=null)
		{
			if(target == null){
				_has=false
			}else{
				_has=true
				targets=target
			}
			_active=a
			_obj=t
			if(_active){
				_obj.addEventListener(GameEvent.ADDED,onAdded)
			}
		}
		public function activate():void
		{
			_active=true
			startTween()
		}
		private function onAdded(e:GameEvent):void
		{
			if(!_has){
				targets=findTargets()
			}
			if(targets.length > 1){
				startTween()
			}
		}
		
		private function startTween():void
		{
			
			var m:*=targets[_tweenIndex]
			trace('startTween',m.x,m.y,_tweenIndex)
			tweenTime=Math.sqrt(Math.pow(m.x-_obj.x,2)+Math.pow(m.y-_obj.y,2))/speed
			trace(tweenTime)
			Tweener.addTween(_obj,{x:m.x,y:m.y,time:tweenTime,onComplete:update})
		}
		
		private function update():void
		{
			trace('update')
			_tweenIndex++
			if(_tweenIndex > targets.length-1){
				_tweenIndex=0
				startTween()
			}
		}
		
		private function findTargets():Array
		{
			var arr:Array=[{x:_obj.x,y:_obj.y,index:-2}]
			var name:String=_obj.name
			for(var i:uint=0;i<_obj.world.numChildren;i++){
				var t:DisplayObject=_obj.world.getChildAt(i)
				if(t is MotionTarget && t != _obj){
					var r0:RegExp=new RegExp(name+"_"+suffix+"([0-9]*)")
					var match:Boolean=r0.test(t.name)
					if(match)
					{
						var result:Array=r0.exec(t.name)
						var ind:int=(result[1]=="")?-1:result[1]
						arr.push({obj:t,index:ind})
					}
				}
			}
			arr.sortOn("index")
			var z:Array=[]
			for(i=0;i<arr.length;i++){
				z.push(arr[i].obj)
			}
			return arr
		}
			
	}
}	
		
