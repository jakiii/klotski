package code.mmo.type
{
	import flash.display.MovieClip;
	
	public class TypeBase extends MovieClip
	{
		public var index:int;
		public var h:int;
		public var w:int;
		public var w_grid:int;
		public var h_grid:int;
		public var type:int;
		
		public function TypeBase(index:int, h:int, w:int)
		{
			super();
			this.index = index;
			this.h = h;
			this.w = w;
		}
		
		public function isMyArea(hx:int, wx:int):Boolean
		{
			return (hx >= h && hx < h + h_grid)
			&&(wx >= w && wx < w + w_grid);
		}
	}
}