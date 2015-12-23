package
{
	// Flash library
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.*;
	import flash.events.MouseEvent;	
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	
	import flash.utils.getTimer;
	//import flash.utils.setTimeout;
	
	import org.flashdevelop.utils.*;

	public class Game extends flash.display.Sprite
	{
		private var _background:Sprite;
		private var _gameWidth:Number;
		private var _gameHeight:Number;
		
		private var _ballArray:Array;		
		private var _playerArray:Array;
		
		private var textScore:TextField;
		
		private var lastMouseX:Number;
		
		private var lastTime:uint;
		
		public function Game():void
		{
			stage.frameRate = 120;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.;
			
			_gameWidth=320;
			_gameHeight=360;
			_background=new Sprite();
			addChild(_background);
			lastMouseX=this.mouseX;
			
			_ballArray=new Array();
			_playerArray=new Array();
			
			var pl1:Player=addPlayer("Bot1",_gameWidth/2,10);
			pl1._normal.x=0;
			pl1._normal.y=1;
			
			var pl2:Player=addPlayer("Bot2",_gameWidth/2,_gameHeight-10);
			pl2._normal.x=0;
			pl2._normal.y=-1;
			
			textScore=new TextField();
			textScore.alpha=0.1;
			textScore.selectable=false;
			//textScore.
			textScore.textColor=0x888888;
			textScore.autoSize=TextFieldAutoSize.RIGHT;
			addChild(textScore);
			
			KeyProxy.initialize(stage);
			
			FlashConnect.trace("Main Game started!");
			draw();
			addBall(_gameWidth/2,_gameHeight/2);
			updateScore();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			lastTime=getTimer();			
		}
		
		 public function BlurFilterExample():void {
			var filter:BitmapFilter = getBitmapFilter();
            var myFilters:Array = new Array();
            myFilters.push(filter);
            filters = myFilters;
        }

        private function getBitmapFilter():BitmapFilter {
            var blurX:Number = 5;
            var blurY:Number = 0;
            return new BlurFilter(blurX, blurY, BitmapFilterQuality.LOW);
        }
		
		private function keyPressed(event:KeyboardEvent):void {
            // create a property in keysDown with the name of the keyCode
            if(event.keyCode == Keyboard.NUMPAD_ADD)
			{
				addBall(_gameWidth/2,_gameHeight/2);
			}
			if(event.keyCode == Keyboard.NUMPAD_SUBTRACT)
			{
				if(_ballArray.length>1)
				{
					removeBall(_ballArray[_ballArray.length-1]);
				}
			}
        }
		
		private function onMouseOver(event:MouseEvent):void
		{
			Mouse.hide();
			//addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			Mouse.show();			
			//removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			var pl1:Player=_playerArray[1];
			pl1.x+=this.mouseX-lastMouseX;
			lastMouseX=this.mouseX;
			
			if(pl1.x > _gameWidth - pl1.width/2) pl1.x =_gameWidth - pl1.width/2;
			if(pl1.x < pl1.width/2) pl1.x = pl1.width/2;
		}
		
		public function updateScore():void
		{
			var pl1:Player=_playerArray[0];
			var pl2:Player=_playerArray[1];
			textScore.text= pl1._score.toString()+" / "+pl2._score.toString();
			textScore.x=(_gameWidth - textScore.width)/2;
			textScore.y=(_gameHeight - textScore.height)/2;				
		}
		
		public function addPlayer(name:String,posX:int,posY:int):Player
		{
			var player:Player=new Player(name,30,3,0xFFFFFF);
			_playerArray.push(player);
			addChild(player); 
			player.x=posX;
			player.y=posY;
			return player;
		}
			
		public function addBall(posX:Number,posY:Number):Ball
		{			
			var ball:Ball=new Ball(6,0xFFFFFF);
			_ballArray.push(ball);
			addChild(ball);
			ball.x=posX;
			ball.y=posY;
			ball._speed=50;
			return ball;
		}
		
		public function removeBall(ball:Ball):void
		{
			_ballArray.splice(_ballArray.indexOf(ball),1);			
			removeChild(ball);
		}
			
		private function draw():void
		{
			// on vide le movieClip
            _background.graphics.clear();
			// fill _background with black
			_background.graphics.beginFill(0);
				_background.graphics.drawRect(0,0,_gameWidth,_gameHeight);
			_background.graphics.endFill();
			// game border
			_background.graphics.lineStyle(2, 0xFFFFFF);
			_background.graphics.drawRect(0,0,_gameWidth,_gameHeight);
		
		}
		
		private function move(timeRatio:Number):void{
					
			for (var i:int=0;i<_ballArray.length;i++)
			{
				var ball:Ball=_ballArray[i];
				//move Ball
				ball.x=ball.x+ball._dir.x*ball._speed*timeRatio;
				ball.y=ball.y+ball._dir.y*ball._speed*timeRatio;
				
				//***  check collision ***
				
				//right border
				if(ball.x-ball._radius<0)
				{
					//correct position
					ball.x=ball._radius;
					//change direction
					ball._dir.x=-ball._dir.x;
				}
				
				//left border
				if(ball.x+ball._radius>_gameWidth)
				{
					//correct position
					ball.x= _gameWidth - ball._radius ;
					//change direction
					ball._dir.x=-ball._dir.x;					
				}
								
				
				//player collision
				var pl:Player=_playerArray[0];
				var proj1:Vector;
				var proj2:Vector;
				var n:Vector;
				
				//top player
				if( (ball.y-ball._radius) < pl.y && (ball.x + ball._radius) > (pl.x - pl.width/2) &&( ball.x - ball._radius) < (pl.x + pl.width/2 ) )
				{
					//correct position
					ball.y=pl.y+ball._radius;
					//change direction
					//ball._dir.y=-ball._dir.y;
					
					n = pl._normal.clone();
					n.x= ((ball.x-pl.x)/(pl._width/2))*0.4;
					n.unitize();
					proj1 = ball._dir.proj(n.rNorm());
					proj2 = ball._dir.proj(n);
					
					proj2.x = -proj2.x;
					proj2.y = -proj2.y;
					
					ball._dir=proj1.add(proj2);
					
					//ball.updateFilter();
					//pl.updateFilter();
				}
				
				var pl1:Player=_playerArray[1];								
				
				//bottom player
				if( (ball.y+ball._radius) > pl1.y && (ball.x + ball._radius) > (pl1.x - pl1.width/2) && (ball.x - ball._radius) < (pl1.x + pl1.width/2) )
				{
					//correct position
					ball.y = pl1.y-ball._radius;
					//change direction
					//ball._dir.y=-ball._dir.y;
					
					n = pl1._normal.clone();
					n.x= ((ball.x-pl1.x)/(pl1._width/2))*0.4;
					n.unitize();
					proj1 = ball._dir.proj(n.rNorm());
					proj2 = ball._dir.proj(n);
					
					proj2.x = -proj2.x;
					proj2.y = -proj2.y;
					
					ball._dir = proj1.add(proj2);
					ball._dir.unitize();
					if(ball._dir.y>-0.5 )
					{
						ball._dir.y=-0.5;
						ball._dir.unitize();
					}
				}
					
				var remove:Boolean = false;
				//top border
				if(ball.y-ball._radius<0)
				{	
					pl1._score++;
					remove= true;
					//correct position
					//ball.y=ball._radius;
					//change direction
					//ball._dir.y=-ball._dir.y;
				}
				
				//bottom border
				if(ball.y+ball._radius>_gameHeight)
				{
					pl._score++;
					//correct position
					remove=true;
					//ball.y=_gameHeight-ball._radius;
					//change direction
					//ball._dir.y=-ball._dir.y;
				}
				if(remove){
					removeBall(ball);
					addBall(_gameWidth/2,_gameHeight/2);
					updateScore();
				}
				
				//increase ball speed
				ball._speed+= timeRatio*15;
			}
			
		}
		
		
		private function onEnterFrame(event:Event):void
		{	
			var thisTime:uint=getTimer();
			var timeRatio:Number=(thisTime - lastTime)/1000;
			lastTime=thisTime;
			
				
			
			// AI PLAYER	
			var speed:Number = 200;
			var aiPlayer:Player=_playerArray[0];
			
			var ball:Ball;
			var ballDist:Number;
			var vCalc:Vector=new Vector();
			//search ball to target
			for(var iBall:int=0; iBall < _ballArray.length; iBall++)
			{
				var b:Ball=_ballArray[iBall];
				
				if(b._dir.y<0) //valid direction
				{
					//first ?
					if(ball==null)
					{
						ball=b;
						vCalc.x=b.x-aiPlayer.x;
						vCalc.y=b.y-aiPlayer.y;						
						ballDist=vCalc.length();
					}
					else
					{//plus près ?
						vCalc.x=b.x-aiPlayer.x;
						vCalc.y=b.y-aiPlayer.y;	
						var dTmp:Number=vCalc.length();
						if(dTmp<ballDist)
						{
							ballDist=dTmp;
							ball=b;
						}
					}
				}
			}
			
			if(ball!=null)
			{
				var dist:Number=ball.x-aiPlayer.x;
				var dec:Number=(0.5-Math.random() +0.5) * 10;
				dist+=dec;
				
				if(dist>0)
				{
					var moveA:Number=speed*timeRatio;
					if(dist<moveA)
						aiPlayer.x += dist;
					else
						aiPlayer.x += moveA;
										
					if(aiPlayer.x > _gameWidth - aiPlayer.width/2) aiPlayer.x =_gameWidth - aiPlayer.width/2;			
				}				
				if(dist<0)
				{
					var moveB:Number=-speed*timeRatio;
					if(dist>moveB)
						aiPlayer.x += dist;
					else
						aiPlayer.x += moveB;
						
					if(aiPlayer.x < aiPlayer.width/2) aiPlayer.x = aiPlayer.width/2;
				}
			}
			
			
			// HUMAN PLAYER				
			var pl1:Player=_playerArray[1];	
			speed=8;
			if(KeyProxy.isDown(Keyboard.RIGHT))
			{				
				pl1.x += speed*timeRatio;
				if(pl1.x > _gameWidth - pl1.width/2) pl1.x =_gameWidth - pl1.width/2;
			}
			
			if(KeyProxy.isDown(Keyboard.LEFT))
			{
				pl1.x -= speed*timeRatio;
				if(pl1.x < pl1.width/2) pl1.x = pl1.width/2;
			}
			
						
			move(timeRatio);		
			
		}
	}
}
