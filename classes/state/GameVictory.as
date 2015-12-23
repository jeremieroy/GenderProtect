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

	public class GameVictory implements IState
	{	
		private var _app:StateApplication;
		private var _view:Sprite;
		private var _title:TextField;
		
		public function GameVictory(app:StateApplication)
		{
			FlashConnect.trace("GameVictory constructor");
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
			
			_title.text = "Respect!\r\n Il s'agira ...";
			_title.width=150;
			_title.x=(_app._width-_title.textWidth)*0.5;
			_title.y=(_app._height-_title.textHeight)*0.5;
		
			_view.addChild(_title);			
		}
		
		// called on entering the state 
		public function enter():void
		{
			FlashConnect.trace("GameVictory Enter");	
			_app.addChild(_view);			
		}
		
		// called on leaving the state 
		public function exit():void
		{
			FlashConnect.trace("GameVictory Exit");
			_app.removeChild(_view);			
		}
		
		private var _elapsedTime:int=0;
		private var _boyArray:Array;
		private var _bigBoy:GenderZone;
		// called every frame while in the state 
		public function update( time:int ):void
		{
			_elapsedTime += time;
			
			if(_elapsedTime<4000)
			{
				_title.text = "Respect!\r\n Il s'agira ..."+((4000-_elapsedTime)/1000).toString();
			}else			
			{				
				if(_boyArray==null)
				{
					_title.text ="";
					_bigBoy=new GenderZone(new Vector(_app._width/2,_app._height/2),true);
					_bigBoy.x= _bigBoy._pos.x;
					_bigBoy.y= _bigBoy._pos.y;
					_view.addChild(_bigBoy);
					_bigBoy.scaleX=3;
					_bigBoy.scaleY=3;
					_boyArray=new Array();
					for(var i:int=0;i<30;i++)
					{						
						var boy:GenderZone=new GenderZone(new Vector(Math.random()*_app._width,Math.random()*_app._height),true);
						
						 boy.x= boy._pos.x;
						 boy.y= boy._pos.y;
						 boy.rotation=Math.random()*360;
						 boy._speed=Math.random()*boy._speed*8;
						_boyArray.push(boy);
						_view.addChild(boy);
						
					}
				}else
				{
					_bigBoy.update(time);
					for(var j:int=0;j<_boyArray.length;j++)
					{
						var boy2:GenderZone=_boyArray[j];
						boy2.update(time);
					}
				}
				
			}
		}	
	
	}
	
}