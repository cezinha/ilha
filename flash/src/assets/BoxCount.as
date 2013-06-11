package assets {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class BoxCount extends MovieClip {
		private var _counter : Number = 0;
		private var TOTAL : Number = 5;
		public var txtCounter : TextField;

		public function BoxCount() {
			// constructor code
			txtCounter.text = String(_counter);
		}
		
		public function update(num:Number) {
			_counter = num;
			txtCounter.text = String(num);
		}
	}	
}
