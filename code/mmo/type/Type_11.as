package code.mmo.type
{
	import code.mmo.config.TypeConfig;

	public class Type_11 extends TypeBase
	{
		public function Type_11(index:int, h:int, w:int)
		{
			super(index, h, w);
			this.w_grid = 1;
			this.h_grid = 1;
			this.type = TypeConfig.TYPE_1_1;
		}
	}
}