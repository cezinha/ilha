﻿// Feel free to use this code in any way you see fit// www.warmforestflash.compackage com.warmforestflash.drawing{	import flash.display.Shape;	import flash.display.BitmapData;	import flash.geom.Rectangle;	public class DottedLine extends Shape	{		private var _w:Number;		private var _h:Number;		private var _color:uint;		//private var _dotAlpha:Number;		private var _dotWidth:Number;		private var _spacing:Number;				//============================================================================================================================		public function DottedLine(w:Number = 100, h:Number = 1, color:uint = 0x777777, dotAlpha:Number = 1, dotWidth:Number = 1, spacing:Number = 1)		//============================================================================================================================		{			_w = w;			_h = h;			_color = color;			this.alpha = dotAlpha;			_dotWidth = dotWidth;			_spacing = spacing;			drawDottedLine();		}				//============================================================================================================================		private function drawDottedLine():void		//============================================================================================================================		{			graphics.clear();			var tile:BitmapData = new BitmapData(_dotWidth + _spacing, _h + 1, true);			var r1:Rectangle = new Rectangle(0, 0, _dotWidth, _h);			var argb:uint = returnARGB(_color, 255);			tile.fillRect(r1, argb);			var r2:Rectangle = new Rectangle(_dotWidth, 0, _dotWidth + _spacing, _h);			tile.fillRect(r2, 0x00000000);			graphics.beginBitmapFill(tile, null, true);			graphics.drawRect(0, 0, _w, _h);			graphics.endFill();		}				//============================================================================================================================		private function returnARGB(rgb:uint, newAlpha:uint):uint		//============================================================================================================================		{			var argb:uint = 0;			argb += (newAlpha<<24);			argb += (rgb);			return argb;		}			}}