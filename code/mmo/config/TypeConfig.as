package code.mmo.config
{
	public class TypeConfig
	{
		public function TypeConfig()
		{
		}
		
		public static const Type_0_0:int = 0;
		public static const TYPE_1_1:int = 1;
		public static const TYPE_1_2:int = 2;
		public static const TYPE_2_2:int = 3; //boss
		
		public static function getH_W(type:int):Array
		{
			switch(type)
			{
				case Type_0_0:
					return [1,1];
				case TYPE_1_1:
					return [1,1];
				case TYPE_1_2:
					return [2,1];
				case TYPE_2_2:
					return [2,2];
			}
			throw new Error("getH_W未定义的type:"+type);
			return null;
		}
		
		public static function getMaterialStr(type:int):String
		{
			switch(type)
			{
				case Type_0_0:
					return "00";
				case TYPE_1_1:
					return "01";
				case TYPE_1_2:
					return "10";
				case TYPE_2_2:
					return "11";
			}
			throw new Error("getMaterialStr未定义的type:"+type);
			return null;
		}
	}
}