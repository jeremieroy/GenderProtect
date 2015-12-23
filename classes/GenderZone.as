/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class GenderZone extends flash.display.Sprite {
	
		[Embed(source="male.png")]
        private var maleEmbed:Class;
		[Embed(source="female.png")]
        private var femaleEmbed:Class;
		
		public var _pos:Vector;
		public var _malePos:Vector;
		public var _femalePos:Vector;
		public var _speed:Number;
		public var _rotation:Number;
		public function GenderZone( pos:Vector, maleOnly:Boolean ):void
		{
			_malePos= new Vector(-18,0);
			_femalePos= new Vector(18,0);
			_speed=10;
			_rotation=0;
			
			var maleImg:Bitmap = new maleEmbed(); 
			 maleImg.smoothing=true;
			addChild(maleImg);
			if(maleOnly){
				maleImg.x=-maleImg.width/2;
				maleImg.y=-maleImg.height/2;
			}else{
				maleImg.x=_malePos.x-maleImg.width/2;
				maleImg.y=_malePos.y-maleImg.height/2;
				var femaleImg:Bitmap = new femaleEmbed(); 
				femaleImg.smoothing=true;
				addChild(femaleImg);	
				femaleImg.x=_femalePos.x-maleImg.width/2;
				femaleImg.y=_femalePos.y-maleImg.height/2;
			}
						
			
			
			_pos = pos;			
			//updateFilter();
		}	
		
		public function update( time:int ):void
		{
			this.rotation+=_speed*(time/1000);
			if(rotation>360)rotation-=360;
		}
		
	}
	
}
