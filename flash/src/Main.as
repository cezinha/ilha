package 
{
	import assets.Foto;
	import br.com.stimuli.loading.BulkLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class Main extends Sprite 
	{
		private var _fotos : Vector.<Foto>;
		public var txt : TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Security.loadPolicyFile("http://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
			Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("https://profile.ak.fbcdn.net/crossdomain.xml");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");		
			
			var loader : BulkLoader = new BulkLoader("main-loader");
			_fotos = new Vector.<Foto>();
			_fotos[0] = this.getChildByName("mcFoto01") as Foto;
			_fotos[1] = this.getChildByName("mcFoto02") as Foto;
			_fotos[2] = this.getChildByName("mcFoto03") as Foto;
			_fotos[3] = this.getChildByName("mcFoto04") as Foto;
			_fotos[4] = this.getChildByName("mcFoto05") as Foto;
			
			txt.appendText('init\n');
			txt.visible = false;
			
			try {
				txt.appendText('check\n');
				if (ExternalInterface.available) {
					//call from javascript
					//ExternalInterface.addCallback("addFriend", addFriend);
					//ExternalInterface.addCallback("removeFriend", removeFriend);
					ExternalInterface.addCallback("updateFriends", updateFriends);
					ExternalInterface.call("console.log", "ready");
					txt.appendText('ready\n');
				}
			} catch (e:Error) {
				txt.appendText('error: ' + e.message);
			}

		}
		
		public function updateFriends(arr): void {
			var len = _fotos.length;
			for (var i = 0; i < len; i ++) {
				if (arr[i].id == '-1') {
					_fotos[i].unload();
				} else {
					_fotos[i].load(arr[i].id);
				}
			}
		}
		
		public function addFriend(id, pos):void {
			txt.appendText('addFriend: ' + id + ', ' + pos + '\n');
			_fotos[pos].load(id);
		}
		
		public function removeFriend(pos):void {
			txt.appendText('removeFriend: ' + pos + '\n');
			_fotos[pos].unload();
		}
	}	
}