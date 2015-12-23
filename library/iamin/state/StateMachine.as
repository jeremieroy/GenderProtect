package iamin.state 
{
	import iamin.state.IState;
	import de.polygonal.ds.ArrayedStack;
	//import de.polygonal.ds.Iterator;
	
	public class StateMachine 
	{ 
		private var _currentState:IState = null;
		//assume a maximum of 512 items
		private var _stateStack:ArrayedStack = new ArrayedStack(512);
		
		public function StateMachine() 
		{ 
		
		}
		
		public function get currentState():IState 
		{
			return _currentState;
		}
		
		// prepare a state for use after the current state 
		public function setState( s:IState ):void 
		{ 			
			//clear the whole state stack
			while (!_stateStack.isEmpty())
			{
				var top:IState = _stateStack.pop() as IState;
				top.exit(); 
			}
						
			pushState(s);
		}
			
		// Update the FSM. Parameter is the frametime for this frame. 
		/*
		public function update( time:int ):void 
		{ 
			if( _currentState ) 
			{ 
				_currentState.update( time ); 
			} 
		} */
		// Change back to the previous state 
		public function pushState(s:IState ):void 
		{ 
			_stateStack.push(s);
			_currentState = s;
			s.enter();	
		} 
		
		// Go to the next state 
		public function popState():void 
		{ 
			var top:IState = _stateStack.pop() as IState;
			
			_currentState = _stateStack.peek() as IState;
			top.exit();
		} 
	}
}