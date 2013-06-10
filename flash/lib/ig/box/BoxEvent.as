package ig.box {
	import flash.events.Event;

	/**
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class BoxEvent extends Event {
		//  PUBLIC PROPERTIES -------------------------------------------------------------------------------------		
		public static const HIDE : String = "hide";
		//  PRIVATE PROPERTIES ------------------------------------------------------------------------------------
		
		//  CONSTRUCTOR -------------------------------------------------------------------------------------------
		public function BoxEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		//  PUBLIC METHODS ----------------------------------------------------------------------------------------
		//  PRIVATE METHODS ---------------------------------------------------------------------------------------
		//  EVENT HANDLERS ----------------------------------------------------------------------------------------		
		//  GETTERS & SETTERS METHODS -----------------------------------------------------------------------------
	}
}
