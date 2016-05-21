package mmo.type
{
	import mmo.config.TypeConfig;

	public class Type_12 extends TypeBase
	{
		public function Type_12(index:int, h:int, w:int)
		{
			super(index, h, w);
			this.h_grid = 2;
			this.w_grid = 1;
			this.type = TypeConfig.TYPE_1_2;
		}
	}
}