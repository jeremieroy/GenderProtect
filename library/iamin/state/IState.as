package iamin.state 
{
	public interface IState 
	{ 
		// called on entering the state 
		function enter():void;
		// called on leaving the state 
		function exit():void; 		
	}
	
}