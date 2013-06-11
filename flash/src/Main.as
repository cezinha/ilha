package 
{
	import assets.BoxCount;
	import assets.Friends;
	import assets.FriendsEvent;
	import assets.Servico;
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.facebook.graph.Facebook;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import Config;
	
	/**
	 * ...
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class Main extends MovieClip 
	{
		private var _servico : Servico;
		public var txt : TextField;
		public var mcBoxCount : BoxCount;
		public var mcFriends : Friends;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			Security.loadPolicyFile("https://graph.facebook.com/crossdomain.xml");
			Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			Security.allowDomain("ilha.herokuapp.com");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");		
						
			txt.appendText('init\n');
			
			try {
				txt.appendText('check\n');
				if (ExternalInterface.available) {
					//call from javascript
					ExternalInterface.addCallback("updateFriends", updateFriends);
					ExternalInterface.addCallback("preview", preview);
					
					ExternalInterface.call("console.log", "ready");
					txt.appendText('ready\n');
				}
			} catch (e:Error) {
				txt.appendText('error: ' + e.message);
			}

			Facebook.init(Config.FB_APP_ID, onFacebookLoaded, { status:false } );
			Facebook.login(onFacebookLoaded, {scope:'publish_stream, user_photos'});

			_servico = new Servico();
			
		}
				
		private function onFacebookLoaded(success:Object, fail:Object):void
		{
			txt.appendText('FB.init\n');
		}
		
		public function updateFriends(arr): void {
			var count = mcFriends.update(arr);			
			mcBoxCount.update(count);
		}
		
		public function preview():void {
			mcBoxCount.visible = false;
			
			mcFriends.addEventListener(FriendsEvent.CONFIRM, onFriendsConfirm);
			mcFriends.addEventListener(FriendsEvent.CANCEL, onFriendsCancel);
		}
		
		public function onFriendsConfirm(e:FriendsEvent):void {
			var w = 600;
			var h = 235;
			var bitmapData : BitmapData = new BitmapData(w, h, true, 0xFFFFFF);
			var drawingRectangle:Rectangle =  new Rectangle(0, 0, w, h);
			bitmapData.draw(mcFriends, new Matrix(), null, null, drawingRectangle, false);
            
			var encoder : JPGEncoder = new JPGEncoder(80);
			var bytes : ByteArray = encoder.encode(bitmapData);
			
			var friends : Array = mcFriends.friends;
			var len : Number = friends.length;
			var tags : Array = new Array();
			var pos : Array = [ { x: 10, y: 10 }, { x: 30, y: 20 }, { x: 50, y: 15 }, { x: 70, y: 15 }, { x: 90, y: 20 } ];
			
			for (var i = 0; i < len; i++) {
				tags.push( { to: friends[i].id, x: pos[i].x, y: pos[i].y } );
			}
			
			var params = {
				message : "Mensagem de teste ",
				image : bytes,
				fileName: 'FILE_NAME',
				tags: tags
			};	
			
			Facebook.api('/me/photos', onPostouFoto, params, "POST");
			
			if (ExternalInterface.available) {
				ExternalInterface.call("App.saved");
			}
		}
		
		public function onFriendsCancel(e:FriendsEvent) {
			if (ExternalInterface.available) {
				ExternalInterface.call("App.cancel");
			}
		}
		
		private function onPostouFoto(resultado:Object, falha:Object):void
		{
			if ( resultado != null ) {
				/*if (ExternalInterface.available) {
					ExternalInterface.call("saved");
				}*/
				txt.appendText('saved: ' + resultado.id);
				//ExternalInterface.call("console.log", resultado.id);
			}
		}
	}	
}