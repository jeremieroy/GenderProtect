package iamin.utils
{
	import flash.display.Sprite;	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.system.System;	
	import flash.net.LocalConnection;

	public class FpsCounter extends Sprite
	{
		private var _counter:int=0;
		private var _memMax:int=0;
		private var _memMin:int=0xFFFFF0;
		
		private var _memLastS:int=0;
		private var _memLastGC:int=0;
		
		private var _memGainS:int=0;
		private var _memGainGC:int=0;
		//private var _memAvg:int=0;
		private var _counterDisplay:TextField;

		private var _updateID:uint=0;
		public var isStarted:Boolean;
		public function FpsCounter(dark:Boolean)
		{			
			// Textfield setup
			_counterDisplay=new TextField();
			_counterDisplay.border=true;
			_counterDisplay.background=true;
			_counterDisplay.selectable=false;
			_counterDisplay.autoSize=TextFieldAutoSize.LEFT;
			
			var format:TextFormat = new TextFormat();
            format.font = "Verdana";            
            format.size = 8;

            _counterDisplay.defaultTextFormat = format;
			
			if(dark)
			{
				_counterDisplay.borderColor=0xFFFFFF;
				_counterDisplay.textColor=0xFFFFFF;
				_counterDisplay.backgroundColor=0x000000;
			}else{
				_counterDisplay.borderColor=0x000000;
				_counterDisplay.textColor=0x000000;
				_counterDisplay.backgroundColor=0xFFFFFF;			
			}
			
			updateCounter();
			addChild(_counterDisplay);
			isStarted=false;
		}
		
		public function Start():void
		{
			//check already running
			if(_updateID!=0) return;
			_updateID=setInterval(updateCounter,1000);
			addEventListener(Event.ENTER_FRAME, onEnterFrameEvent,false, 0, true);	
			isStarted=true;
		}
		
		public function Stop():void
		{
			clearInterval(_updateID);
			removeEventListener(Event.ENTER_FRAME,onEnterFrameEvent);
			_updateID=0;
			isStarted=false;
		}
		
		private function onEnterFrameEvent(event:Event):void
		{
			_counter++;
		}
		
		private function updateCounter():void
		{
			var mem:int=int(System.totalMemory>>10);
			if(mem>_memMax) _memMax=mem;
				
			_memGainS=mem-_memLastS;
			_memLastS=mem;
			if(_memGainS<0)
			{
				//it's a GC update 
				_memGainGC=mem-_memLastGC;
				_memLastGC=mem;
			}
			var s:String="FPS:"+ _counter.toString();
			if(_memGainS>0)
				s+="  MEM(KB):"+mem.toString()+" (+"+_memGainS+") / ";
			else
				s+="  MEM(KB):"+mem.toString()+" ("+_memGainS+") / ";
			if(_memGainGC >0)			
				s+=_memMax.toString()+" (+"+_memGainGC+")";
			else
				s+=_memMax.toString()+" ("+_memGainGC+")";
			_counterDisplay.text=s;
			_counter=0;
		}
		
		//Force garbage collection
		private static function ForceGCUpdate():void
		{
			// the GC will perform a full mark/sweep on the second call.		
			try {				
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			} catch (e:*) {}
		}
	
	}
}