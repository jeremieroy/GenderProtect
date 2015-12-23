/**
* ...
* @author Default
* @version 0.1
*/

package state {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.*; 
	
	import iamin.state.IState;
	import iamin.state.StateApplication;
	
	import org.flashdevelop.utils.FlashConnect;

	public class Intro implements IState
	{	
		private var _app:StateApplication;
		private var _view:Sprite;
		private var _title:TextField;
		
		public function Intro(app:StateApplication)
		{
			FlashConnect.trace("Intro constructor");
			_app=app;			
			
			//Create Title Screen
			_view=new Sprite();
			
			// Textfield setup
			_title=new TextField();
			//_title.border=true;
			//_title.background=true;
			_title.selectable=false;
			_title.multiline = true;
			_title.wordWrap = true;
			_title.mouseEnabled = false; 
			_title.autoSize=TextFieldAutoSize.LEFT;
			
			var format:TextFormat = new TextFormat();
            format.font = "Lucida Grande";
            format.size = 13;
			format.bold = true;			
			
            _title.defaultTextFormat = format;			
			_title.textColor = 0xFFFFFF;
			_title.backgroundColor = 0x000000;
			
			_title.text = "Alice & Jeremie Productions Presents\r\n [The Gender Game]\r\n Il vous suffit de tenir 30s.\r\nCliquez ici pour commencer ...";
			_title.width=170;
			_title.x=(_app._width-_title.textWidth)*0.5;
			_title.y=(_app._height-_title.textHeight)*0.5;
			
			_view.addChild(_title);
			
		}
		
		// called on entering the state 
		public function enter():void
		{
			FlashConnect.trace("Intro Enter");	
			_app.addChild(_view);
			_view.addEventListener(MouseEvent.CLICK, onMouseClickEvent,false,0,true);
		}
		
		// called on leaving the state 
		public function exit():void
		{
			FlashConnect.trace("Intro Exit");
			_app.removeChild(_view);			
		}
		
		private var _elapsedTime:int=0;
		// called every frame while in the state 
		public function update( time:int ):void
		{			
			_elapsedTime += time;
			
			//var nMS:int=1000;			
			//_title.alpha=((_elapsedTime%nMS)/nMS)*100;
			//_title.textColor++;			
			
			//FlashConnect.trace(_title.alpha.toString());
		}

		public function onMouseClickEvent(event:Event):void
		{    
			_app.changeState(new GameRun(_app));			
		}
	
	}
	
}