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
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import iamin.state.IState;
	import iamin.state.StateApplication;
	import flash.ui.Mouse;
	import org.flashdevelop.utils.FlashConnect;
	
	import com.adobe.utils.ArrayUtil;

	public class GameRun implements IState 
	{
		private var _app:StateApplication;		
		private var _title:TextField;
		private var _ballArray:Array;
			
		public function GameRun(app:StateApplication) 
		{ 
			_app=app;			
			
						
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
			
			_title.text = "";
			
			
			_protector=new Protector(new Vector(app._width/2,app._height/2));
			_genderZone=new GenderZone(new Vector(app._width/2,app._height/2),false);
			_genderZone.x=_genderZone._pos.x;
			_genderZone.y=_genderZone._pos.y;
			_ballArray=new Array();
			
		}
		
		private var _genderZone:GenderZone; 
		private var _protector:Protector; 
		// called on entering the state 
		public function enter():void
		{
			FlashConnect.trace("GameRun Enter");	
			_app.addChild(_title);
			_app.addChild(_protector);			
			_app.addChild(_genderZone);	
			_updateID=setInterval(updateCounter,500);
		}
		
		// called on leaving the state 
		public function exit():void
		{
			Mouse.show();
			FlashConnect.trace("GameRun Exit");
			_app.removeChild(_title);
			_app.removeChild(_protector);
			_app.removeChild(_genderZone);	
			clearInterval(_updateID);
			for(var i:int=0;i<_ballArray.length;i++)
			{
				var ball:Ball=_ballArray[i];
				_app.removeChild(ball);
			}			
		}
		
		private var _elapsedTime:int=0;
		private var _elapsedBallTime:int=0;
		private var _ballLaunchTime:int=800;
		private var _gameDuration:int=30000;
		// called every frame while in the state 
		public function update( time:int ):void
		{
			_elapsedTime += time;
			_elapsedBallTime+=time;
			Mouse.hide();
			
			_protector.setPosition(_app.mouseX,_app.mouseY);
			_protector.draw();
			
			_genderZone.update(time);
			_genderZone._speed+= (time/_gameDuration)*360;
						
		
			if(_elapsedBallTime>_ballLaunchTime)
			{
				addBall();
				_elapsedBallTime=0;
				_ballLaunchTime=800 - (_elapsedTime/_gameDuration)*400;
			}
			
			var toRemove:Array=new Array();
			for(var i:int=0;i<_ballArray.length;i++)
			{
				var ball:Ball=_ballArray[i];
				//move
				ball.update(time);
				//check collision
				if(ball._chasing==true)
				{					
					if(_protector._pos.remove(ball._pos).length()<ball._radius)
					{
						ball._dir.negate();
						ball._chasing=false;						
					}else if(_protector._point1.remove(ball._pos).length()<ball._radius)
					{
						ball._dir.negate();
						ball._chasing=false;
					}else if(_protector._point2.remove(ball._pos).length()<ball._radius)
					{
						ball._dir.negate();
						ball._chasing=false;
					}
				}				
				
				//check out of screen 
				if(ball.x<0)
				{
					toRemove.push(ball);
				}
				else if(ball.x>_app._width)
				{
					toRemove.push(ball);
				}
				else if(ball.y>_app._height)
				{
					toRemove.push(ball);
				}
				else if(ball.y<0)
				{
					toRemove.push(ball);
				}			
				
				//check target
				if(_protector._anchor.remove(ball._pos).length()<_protector._genderLimit)
				{
					_app.changeState(new GameOver(_app));
					return;
				}
			}			
			
			for(var j:int=0;j<toRemove.length;j++)
			{
				var ballRem:Ball=toRemove[j];				
				_app.removeChild(ballRem);
				
				ArrayUtil.removeValueFromArray(_ballArray, ballRem);				
			}
			//FlashConnect.trace(_title.alpha.toString());
						
			//check victory
			if(_elapsedTime > _gameDuration )//30s
			{
				_app.changeState(new GameVictory(_app));
				
			}
		}
		private var _updateID:uint=0;
		private function updateCounter():void
		{			
			_title.text=((30000-_elapsedTime)/1000).toString()+" s";
			_title.x=(_app._width-_title.textWidth)*0.5;			
		}
		
		
		public function addBall():Ball
		{			
			//compute posX et posY
			var dec:Number=(0.5-Math.random() +0.5) * 10;
			
			var posX:Number=0;
			var posY:Number=0;
			
			var seed:Number = Math.random();
			if(seed<0.25)
			{//top
				posX=Math.random()*_app._width;				
			}else if(seed<0.5)
			{//bottom
				posX=Math.random()*_app._width;				
				posY=_app._height;
				
			}else if(seed<0.75)
			{//left				
				posY=Math.random()*_app._height;	
				
			}else 
			{//right
				posX=_app._width;
				posY=Math.random()*_app._height;
			}
			var dir:Vector=_protector._anchor.remove(new Vector(posX,posY));
			dir.unitize();
			var pos:Vector=new Vector(posX,posY);			
			var ball:Ball=new Ball(pos,dir,50,6,0x111111);
			_ballArray.push(ball);
			_app.addChild(ball);
			
			return ball;
		}
		
			
	}
	
}
