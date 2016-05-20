package code.mmo.type
{
	import code.mmo.config.TypeConfig;

	public class Type_22 extends TypeBase
	{
		public function Type_22(index:int, h:int, w:int)
		{
			super(index, h, w);
			this.w_grid = 2;
			this.h_grid = 2;
			this.type = TypeConfig.TYPE_2_2;
		}
	}
}