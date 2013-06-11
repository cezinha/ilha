package assets 
{
	//import mx.graphics.codec.PNGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import ru.inspirit.net.MultipartURLLoader;
	import ru.inspirit.net.events.MultipartURLLoaderEvent;

	/**
	 * ...
	 * @author Celina Uemura (cezinha@cezinha.com.br)
	 */
	public class Servico 
	{
		protected var _multi:MultipartURLLoader;
		
		public function Servico() 
		{
			// Upload
			this._multi = new MultipartURLLoader();
			
		}
		
		// BEGIN Upload Stuff
		private function upload(imgData:ByteArray):void
		{
			// Verifica se o snapShot foi disparado
			var hasImage:Boolean = ( getQualifiedClassName(imgData) == 'flash.utils::ByteArray' ) ? true : false;
			
			// Posta os dados
			this._multi.dataFormat = URLLoaderDataFormat.TEXT;
			this._multi.addEventListener(Event.COMPLETE, this.onCompleteUpload);
			
			// Limpa antes
			this._multi.clearFiles();
			this._multi.clearVariables();
			
			// Verifica se tem o snapShot
			if(hasImage)
				_multi.addFile(imgData, 'foto_ilha.png', 'File', 'image/png');
			
			//this._multi.addVariable('flashvalue',String());
			//this._multi.addVariable('finalizado',String());
			//this._multi.load(Config.URL, false);
			// Gravar os dados via API do facebook
		}	
		
		protected function onCompleteUpload(e:Event):void
		{
			/*var r:XML = XML(MultipartURLLoader(e.target).data);
			trace(r);
			if(r[0].@retorno == '1') {
				this._app.objs['id'] = r[0].@id;
			} else {
				trace(r[0].@mensagem);
			}*/
			
			// Limpa e remove a escuta
			this._multi.clearFiles();
			this._multi.clearVariables();
			this._multi.removeEventListener(Event.COMPLETE, this.onCompleteUpload);
		}		
		
		// Helper
		//
		// Tranforma o MovieClip em imagem jpg e encoda para ByteArray
		public static function snapShot(target:MovieClip):ByteArray
		{
			var w = 600;
			var h = 235;
			var x = 60;
			var y = 30;
			var bitmapData:BitmapData = new BitmapData(w, h, true, 0xFFFFFF);
			var drawingRectangle:Rectangle =  new Rectangle(x, y, w, h);
			bitmapData.draw(target, new Matrix(), null, null, drawingRectangle, false);
			//var pe : PNGEncoder = new PNGEncoder();
			return PNGEncoder.encode(bitmapData);
		}
	}
}