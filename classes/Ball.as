/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	
	import org.flashdevelop.utils.FlashConnect;
	
	public class Ball extends flash.display.Sprite {
		
		public var _radius:Number;
		private var _color:uint;
		public var _dir:Vector;
		public var _pos:Vector;
		public var _speed:Number;
		public var _chasing:Boolean;
		
		public function Ball(pos:Vector,dir:Vector,speed:Number,radius:Number,color:uint):void
		{
			_pos=pos;
			_dir=dir;
			_speed=speed;
			_radius=radius;
			_color=color;
			_chasing=true;
			draw();
			cacheAsBitmap=true;
			updateFilter();
        }
		
		private var _elapsedTime:int=0;
		// called every frame while in the state 
		public function update( time:int ):void
		{			
			_elapsedTime += time;
			_pos=_pos.add(_dir.mult(_speed*time/1000));
			x=_pos.x;
			y=_pos.y;
		}
		
		public function updateFilter():void
		{
		    var myFilters:Array = new Array();
			
			//24bit
			
			var r:uint = 32 + Math.random()*223;
			var g:uint = 32 + Math.random()*223;
			var b:uint = 32 + Math.random()*223;
			var color:uint = r << 16 | g << 8 | b;
			
			
			var f:GlowFilter=new GlowFilter(color,0.85,16,16,3,1,false,false);
            myFilters.push(f);
            filters = myFilters;			
			//return filters[0] as BlurFilter;
		}
		
		public function draw():void
		{			
			graphics.beginFill(_color);
				graphics.drawCircle(0,0,_radius);
			graphics.endFill();
		}
		
	}
	
}
