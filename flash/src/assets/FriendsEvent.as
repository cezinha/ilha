package assets 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class FriendsEvent extends Event 
	{
		//  PUBLIC PROPERTIES -------------------------------------------------------------------------------------	
		public static const CONFIRM : String = "confirm";
		public static const CANCEL : String = "cancel";
		
		//  PRIVATE PROPERTIES ------------------------------------------------------------------------------------
		
		//  CONSTRUCTOR -------------------------------------------------------------------------------------------
		public function FriendsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		//  EVENT HANDLERS ----------------------------------------------------------------------------------------			
		//  GETTERS & SETTERS METHODS -----------------------------------------------------------------------------
	}
}