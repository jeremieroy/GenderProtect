package
{
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;

	import flash.geom.Point;	
	
	import flash.ui.Keyboard;
	import flash.events.Event;	
	import flash.utils.getTimer;
	import flash.events.KeyboardEvent;
	//iamin library
	import iamin.state.StateApplication;
	import iamin.utils.FpsCounter;
		
	//flashdevelop library
	import org.flashdevelop.utils.FlashConnect;
	
	//this application specific
	import state.Intro;
	
	public class Main extends StateApplication
	{
		private var _background:Sprite;
		private var _fps:FpsCounter;
		public function Main():void
		{	
			FlashConnect.trace("MainApplication created");
			_width=450;
			_height=450;

			//Add background
			_background=new Sprite();
			_background.cacheAsBitmap=true;
			addChild(_background);
			drawBackground();
						
			stage.frameRate = 240;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align=StageAlign.TOP;
			
			// Add FpsCounter
			_fps=new FpsCounter(true);			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);			

		//start 
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			changeState(new Intro(this));
		}		
	
		private function onKeyDown(event:KeyboardEvent):void {
			if(event.keyCode==Keyboard.F1)
			{
				if(_fps.isStarted==false)
				{
					_fps.Start();
					addChild(_fps);
				}else{
					_fps.Stop();
					removeChild(_fps);
				}
			}
		}
	
		public function drawBackground():void
		{			
			// on vide le movieClip
            _background.graphics.clear();
			// fill _background with black
			_background.graphics.beginFill(0);
				_background.graphics.drawRect(0,0,_width,_height);
			_background.graphics.endFill();
			// game border
			_background.graphics.lineStyle(2, 0xFFFFFF);
			_background.graphics.drawRect(0,0,_width,_height);
		}
		
		private var _lastTime:int=0;
		private function onEnterFrame(event:Event):void
		{
			var thisTime:int=getTimer();
			//var timeRatio:Number=(thisTime - lastTime)/1000;
			
			var elapsedTime:int=thisTime-_lastTime;
			update(elapsedTime);		
			
			_lastTime=thisTime;
		}
	}
	
}
