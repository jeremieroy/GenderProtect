/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import flash.geom.Point;
	import org.flashdevelop.utils.*;
	
	public class Vector /*extends Point*/  {
		
		public var x:Number;
		public var y:Number;
	
		public function Vector(_x:Number=0,_y:Number=0)
		{
			x=_x;
			y=_y;
		}
	
		public function length():Number
		{
			return Math.sqrt(x*x + y*y);			
		}
		
		public function negate():void
		{
			x=-x;
			y=-y;
		}
		
		public function square():Number
		{
			return x*x + y*y;
		}
		
		public function unitize():Number
		{
			var l:Number=length();
			x/=l;
			y/=l;
			return l;
		}
		
		public function dot(v:Vector):Number
		{
			return x*v.x+y*v.y;
		}
		
		public function add(v:Vector):Vector
		{
			return new Vector( x+v.x, y+v.y);
		}
		public function remove(v:Vector):Vector
		{
			return new Vector( x-v.x, y-v.y);
		}
		public function mult(d:Number):Vector
		{
			return new Vector( x*d, y*d);
		}

		
		public function proj(v:Vector):Vector
		{
			//var dp:Number=dot(v);
			//var vD:Number=v.sqLength();
			var p:Number=dot(v)/v.square();
			return new Vector( p* v.x, p*v.y);
		}
		
		public function projUni(v:Vector):Vector
		{
			var dp:Number=dot(v);			
			return new Vector( dp* v.x, dp*v.y);
		}
		
		public function rNorm():Vector
		{	
			return new Vector( -y*2, this.x*2);	
		}
		
		public function lNorm():Vector
		{
			return new Vector( y, -x);
		}
		
		public function clone():Vector
		{
			return new Vector( x, y);
		}
		
		public function toString():String
		{
			return "("+x.toString()+" "+y.toString()+")";
		}		
	}
	
}
