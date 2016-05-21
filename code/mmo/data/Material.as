package mmo.data
{
	public class Material
	{
		public var index:int;
		public var h:int;
		public var w:int;
		public var type:int;
		
		public function Material(index:int, h:int, w:int, type:int)
		{
			this.index = index;
			this.h = h;
			this.w = w;
			this.type = type;
		}
	}
}