/**
* ...
* @author Default
* @version 0.1
*/

package  {

	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	
	import org.flashdevelop.utils.FlashConnect;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	
	public class Protector extends flash.display.Sprite {
		public var _color:uint;
		
		public var _score:int;
		
		public var _pos:Vector;
		public var _point1:Vector;
		public var _point2:Vector;
		public var _dir:Vector;		
		public var _anchor:Vector;
		public var _genderLimit:Number;
		public var _width:Number;
		private var _height:Number;
	
		public function Protector( anchor:Vector ):void
		{
			//FlashConnect.trace("Player created: "+name);
			_width=24;
			_height=3;
			_color=0xCCCCFF;
			_genderLimit=25;
			_dir = new Vector();
			_pos = new Vector();
			_point1 = new Vector();
			_point2 = new Vector();
			_anchor = anchor;
			
			_score = 0;
			
			draw();
			updateFilter();
		}
		
		public function updateFilter():void
		{
		    var myFilters:Array = new Array();
			//(color,0.85,16,16,3,1,false,false);
			var f:GlowFilter=new GlowFilter(0xFF3344,0.75,8,8,2,1,false,false);
            myFilters.push(f);
            filters = myFilters;			
			//return filters[0] as BlurFilter;
		}
		
		public function setPosition(x:Number,y:Number):void
		{
			_pos.x=x;
			_pos.y=y;
		}
			
		public function draw():void
		{	
			//graphics.moveTo(_pos.x,_pos.y);
			//FlashConnect.trace(_pos.x.toString());
			_dir=_pos.remove(_anchor);
			if(_dir.unitize()<_genderLimit)
			{
				_pos=_anchor.add(_dir.mult(_genderLimit));
			}
			var normal:Vector=_dir.lNorm();
			//normal.unitize();
			var halfW:Number=_width/2;
			_point1=_pos.add(normal.mult(halfW));
			_point2=_pos.add(normal.mult(-halfW));
			graphics.clear();
			graphics.lineStyle(_height,_color);
			
			graphics.moveTo(_point1.x,_point1.y);
			graphics.lineTo(_point2.x,_point2.y);
			
			//graphics.beginFill(_color);
				//graphics.drawRect(_pos.x,_pos.y,_width,_height);
				//graphics.drawRect(-(_width/2),-(_height/2),_width,_height);
			//graphics.endFill();
		}
		
	}
	
}
