package assets 
{
	import flash.display.MovieClip;
	import assets.Foto;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class Friends extends MovieClip 
	{
		private var _fotos : Vector.<Foto>;
		private var _friends : Array;
		public var mcFrame : MovieClip;
		public var mcMaskLb : MovieClip;
		public var txtMensagem : TextField;
		public var btnSim : SimpleButton;
		public var btnNao : SimpleButton;
		
		public function Friends() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			gotoAndStop(1);
			
			_fotos = new Vector.<Foto>();
			_fotos[0] = this.getChildByName("mcFoto01") as Foto;
			_fotos[1] = this.getChildByName("mcFoto02") as Foto;
			_fotos[2] = this.getChildByName("mcFoto03") as Foto;
			_fotos[3] = this.getChildByName("mcFoto04") as Foto;
			_fotos[4] = this.getChildByName("mcFoto05") as Foto;
			
			txtMensagem.visible = false;
			btnSim.visible = false;
			btnNao.visible = false;
		}

		public function update(arr:Array):Number {
			_friends = arr;
			var len = _fotos.length;
			var count = 0;
			for (var i = 0; i < len; i ++) {
				if (arr[i].id == '-1') {
					_fotos[i].unload();
				} else {
					count ++;
					_fotos[i].load(arr[i].id);
				}
			}
			
			return count;
		}
		
		public function preview():void {
			gotoAndStop(2);
			
			var users : Array= new Array();
			var nomes : String;
			var len :Number = _friends.length;
			for (var i = 0; i < len; i ++) {
				users.push("<b>" + _friends[i].name + "</b>");
			}
			nomes = users.join(', ');
			nomes = nomes.substring(0, nomes.lastIndexOf(',')) + " e" + nomes.substring(nomes.lastIndexOf(',')+1, nomes.length);

			txtMensagem.htmlText = 'Você escolheu ' + nomes + '.\nSão eles que você quer levar para a ilha?';	
			txtMensagem.visible = true;
			
			btnSim.visible = true;
			btnSim.addEventListener(MouseEvent.CLICK, onSimClick);
			btnNao.visible = true;
			btnNao.addEventListener(MouseEvent.CLICK, onNaoClick);
		}
		
		private function onSimClick(e:Event) : void {
			dispatchEvent(new FriendsEvent(FriendsEvent.CONFIRM));
		}

		private function onNaoClick(e:Event) : void {
			dispatchEvent(new FriendsEvent(FriendsEvent.CANCEL));
		}
		
		public function get friends () : Array {
			return _friends;
		}
	}
}