package ig.box {
	import com.greensock.TweenMax;

	import flash.display.Sprite;

	/**
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class BaseBox extends Sprite implements IBox {
		//  PUBLIC PROPERTIES -------------------------------------------------------------------------------------		
		//  PRIVATE PROPERTIES ------------------------------------------------------------------------------------

		//  CONSTRUCTOR -------------------------------------------------------------------------------------------
		public function BaseBox() {
			this.alpha = 0;
			this.visible = false;
		}
		
		//  PUBLIC METHODS ----------------------------------------------------------------------------------------
		public function show(delay:Number = 0):void {
			TweenMax.killTweensOf(this);
			TweenMax.to(this, 0.4, {autoAlpha:1, delay:delay});
		}
		
		public function hide(delay:Number = 0):void {
			TweenMax.killTweensOf(this);
			TweenMax.to(this, 0.4, {autoAlpha:0, delay:delay, onComplete:function():void {
				dispatchEvent(new BoxEvent(BoxEvent.HIDE));
			}});
		}

		//  PRIVATE METHODS ---------------------------------------------------------------------------------------
		//  EVENT HANDLERS ----------------------------------------------------------------------------------------			
		//  GETTERS & SETTERS METHODS -----------------------------------------------------------------------------
	}
}
