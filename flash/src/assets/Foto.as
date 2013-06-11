package assets 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import ig.box.BaseBox;
	import ig.box.Image;
	import ig.box.ImageEvent;
	
	/**
	 * ...
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class Foto extends Sprite 
	{
		private var _mask : MovieClip;
		private var _pic : BaseBox;
		private var _pin : MovieClip;
		private var _bg : MovieClip;
		private var _id = '';
		private var _loaded = false;
		private var _loader : Loader;
				
		public function Foto() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_mask = this.getChildByName('mcMask') as MovieClip;
			_pin = this.getChildByName('mcPin') as MovieClip;
			_bg = this.getChildByName('mcBg') as MovieClip;
			
			addPic();
		}
		
		private function addPic():void {
			_pic = new BaseBox();
			addChild(_pic);
			_pic.mask = _mask;
			_pic.x = _mask.x - 1;
			_pic.y = _mask.y - 1;
			_bg.visible = false;
			
			_pin.gotoAndStop('off');
			
			//_pic.addEventListener(ImageEvent.COMPLETE, onLoadComplete);			
		}
		
		public function load(id:String):void {
			if (!this._loaded && (this._id != id)) {
				this._loaded = true;
				this._id = id;
				
				_loader = new Loader();			
				var url:URLRequest = new URLRequest("https://graph.facebook.com/" + id + "/picture?width=50&height=50");
				//var loaderContext:LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
				var loaderContext:LoaderContext = new LoaderContext(true, null, SecurityDomain.currentDomain);
				_loader.load(url, loaderContext);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				//loader.load(new URLRequest("https://graph.facebook.com/" + user.uid + "/picture?type=normal"), new LoaderContext(true, null, SecurityDomain.currentDomain);
				//_pic.load("https://graph.facebook.com/" + id + "/picture?width=50&height=50");
			}
		}
		
		public function unload():void {
			if (this._loaded) {
				this._loaded = false;
				this._id = '';
				_bg.visible = true;
				_pic.visible = false;
				_pic.removeEventListener(ImageEvent.COMPLETE, onLoadComplete);
	
				removeChild(_pic);			
	
				addPic();
			}
		}
		
		private function onLoadComplete(e:Event) {
			trace('complete');
			_pic.addChild(_loader.content);
			_bg.visible = false;
			_pic.visible = true;
			_pic.show();
			_pin.gotoAndStop('on');			
		}
	}
}