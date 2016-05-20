package code.mmo.type
{
	import code.mmo.config.TypeConfig;

	public class Type_00 extends TypeBase
	{
		public function Type_00(index:int, h:int, w:int)
		{
			super(index, h, w);
			this.w_grid = 1;
			this.h_grid = 1;
			this.type = TypeConfig.Type_0_0;
		}
	}
}