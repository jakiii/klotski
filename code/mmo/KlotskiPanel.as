package code.mmo
{
	import code.mmo.config.TypeConfig;
	import code.mmo.data.Material;
	import code.mmo.type.TypeBase;
	import code.mmo.type.Type_00;
	import code.mmo.type.Type_11;
	import code.mmo.type.Type_12;
	import code.mmo.type.Type_22;
	
	import flash.display.MovieClip;
	
	public class KlotskiPanel extends MovieClip
	{
		private const Direction:Array = [[-1,0],[1,0],[0,-1],[0,1]]; //上下左右
		private const DirectionDecs:Array = ["上","下","左","右"];
		private const DIRECTION_UP:int = 0;
		private const DIRECTION_DOWN:int = 1;
		private const DIRECTION_LEFT:int = 2;
		private const DIRECTION_RIGHT:int = 3;
		private const GRID_WIDTH:int = 65;
		private const H:int = 5;
		private const W:int = 4;
		
		private const TYPE_NIL:int = 0;
		private const TYPE_ONE:int = 1;
		private const TYPE_W:int = 2;
		private const TYPE_H:int = 3;
		
		private const PosNum:int = 13; //12个格子
		
		private const TotalPos:int = PosNum * 2;
		private var _init:Number;
		private var _mapInt:int = 0;
		
		private var _items:Vector.<TypeBase> = new Vector.<TypeBase>(); 
		private var _alreadyKey:Object = {};
		private var _checkKey:Object = {};
		private var _rightKey:Array = [];
		private var _materials:Array = [];
		
		public function KlotskiPanel()
		{
			super();
//			var initStr:String = "01#11#01#10#10#01#01#10#01#01#10#00#00"; //地图1
//			var initStr:String = "01#00#00#01#10#11#10#10#01#01#10#01#01"; //地图2
			var initStr:String = "01#01#11#10#00#00#10#01#10#01#10#01#01"; //地图3
			initStr = initStr.replace(/#/g,"");
			this._mapInt = parseInt(initStr,2);
			
//			this._mapInt = 24651365;
			trace("init int="+_mapInt);
			this.setMap();
			this.getWays(_materials);
		}
		
		private function getMask():Array
		{
			var mask:Array = [];
			for(var i:int = 0; i < H; i ++)
			{
				mask[i] = [];
				for(var j:int = 0; j < W; j ++)
				{
					mask[i][j] = false;
				}
			}
			return mask;
		}
		
		private function setMap():void
		{
			this._alreadyKey[_mapInt] = true;
			var mask:Object = {};
			var stand:int = 3; //11
			for(var i:int = 0; i < PosNum; i ++)
			{
				var b:int = stand << (TotalPos - (i + 1)*2);
				var type:int = (_mapInt & b)>>(TotalPos - (i + 1)*2);
				var h_w:Array = getH_W(type, mask);
				var mc:TypeBase;
				var material:Material = new Material(i,h_w[0],h_w[1],type);
				switch(type)
				{
					case TypeConfig.Type_0_0:
						mc = new Type_00(i, h_w[0], h_w[1]);
						break;
					case TypeConfig.TYPE_1_1:
						mc = new Type_11(i, h_w[0], h_w[1]);
						break;
					case TypeConfig.TYPE_1_2:
						mc = new Type_12(i, h_w[0], h_w[1]);
						break;
					case TypeConfig.TYPE_2_2:
						mc = new Type_22(i, h_w[0], h_w[1]);
						break;
				}
				mc.y = h_w[0]*GRID_WIDTH;
				mc.x = h_w[1]*GRID_WIDTH;
				this.addChild(mc);
				this._items.push(mc);
				this._materials.push(material);
			}
		}
		
		private function getH_W(type:int, obj:Object):Array
		{
			for(var h:int = 0; h < H; h ++)
			{
				for(var w:int = 0; w < W; w ++)
				{
					if(!obj[h+"_"+w])
					{
						var h_w:Array = TypeConfig.getH_W(type);
						for(var hx:int = h; hx < h + h_w[0]; hx++)
						{
							for(var wx:int = w; wx < w + h_w[1]; wx ++)
							{
								obj[hx+"_"+wx] = true;
							}
						}
						return [h,w];
					}
				}
			}
			throw new Error("getH_W地图有问题type:"+type);
			return null;
		}
		
		private function setBinary(pos:int, n:int):void
		{
			this._init = _init | Math.pow(2,n);
		}
		
		private function getEmptyPos(mtrs:Array):Array
		{
			var arr:Array = [];
			for each(var i:Material in mtrs)
			{
				if(i.type == TypeConfig.Type_0_0)
				{
					arr.push(i);
				}
			}
			return arr;
		}
		
		private function getWays(materials:Array):void
		{
			for each(var o:Material in materials)
			{
				var results:Array = checkCanMove(o, materials);
				if(results != null)
				{
					for(var i:int = 0; i < results.length; i ++)
					{
						var mtrs:Array = results[i];
						var mapInt:int = getMapInt(mtrs);
						trace("key:"+mapInt);
						if(!_alreadyKey[mapInt])
						{
							this._rightKey.push(mapInt);
//							getWays(mtrs);
						}
					}
				}
			}
		}
		
		private function getMapInt(materials:Array):int
		{
			var str:String = "";
			for(var i:int = 0; i < materials.length; i ++)
			{
				str += TypeConfig.getMaterialStr(materials[i].type);
			}
			return parseInt(str,2);
		}
		
		private function checkCanMove(mtr:Material, materials:Array):Array
		{
			if(mtr.type == TypeConfig.Type_0_0)
			{
				return null;
			}
			var emptys:Array = getEmptyPos(materials);
			var h_w:Array = TypeConfig.getH_W(mtr.type);
			//上下左右
			var materialsResult:Array = [];
			
			for(var d:int = 0; d < Direction.length; d ++)
			{
				var afterH:int = mtr.h + Direction[d][0];
				var afterW:int = mtr.w + Direction[d][1];
				
				var n:int = 0;
				
				var pos:Array = [];
				if(d == DIRECTION_UP || d == DIRECTION_DOWN)
				{
					n = h_w[1];
					for(var i:int = 0; i < n; i ++)
					{
						pos.push([afterH,afterW + i]);
					}
				}else
				{
					n = h_w[0];
					for(var j:int = 0; j < n; j ++)
					{
						pos.push([afterH + j, afterW]);
					}
				}
				
				var canMove:Boolean = true;
				for(var k:int = 0; k < pos.length; k ++)
				{
					var hit:Boolean = false;
					for each(var o:Material in emptys)
					{
						if(pos[k][0] == o.h && pos[k][1] == o.w)
						{
							hit = true;
						}
					}
					if(!hit)
					{
						canMove = false;
					}
				}
				if(canMove)
				{
					if(mtr.index == 9)
					{
						this.traceMaterials(materials);
						var newMaterial:Array = this.genNewMaterials(mtr,d,materials);
						materialsResult.push(newMaterial);
						trace(mtr.index+",direction="+DirectionDecs[d] + "__________");
						this.traceMaterials(newMaterial);
					}
				}
			}
			if(materialsResult.length == 0)
			{
				return null;
			}
			return materialsResult;
		}
		
		private function genNewMaterials(mtr:Material, direction:int, materials:Array):Array
		{
			var newMaterials:Array = copyMaterials(materials);
			
			var afterH:int = mtr.h + Direction[direction][0];
			var afterW:int = mtr.w + Direction[direction][1];
			
			var h_w:Array = TypeConfig.getH_W(mtr.type);
			var pos:Array = [];
			var n:int;
			var empty:Material;
			
			if(direction == DIRECTION_UP || direction == DIRECTION_DOWN)
			{
				n = h_w[1];
				for(var i:int = 0; i < n; i ++)
				{
					empty = this.getMaterial(afterH, afterW + i, newMaterials);
					trace("type="+empty.type+"_empty_h="+empty.h + "_w="+empty.w);
					empty.h = empty.h + Direction[direction][0]*-1;
					empty.w = empty.w + Direction[direction][1]*-1;
					trace("type="+empty.type+"_empty_h="+empty.h + "_w="+empty.w);
				}
			}else
			{
				n = h_w[0];
				for(var j:int = 0; j < n; j ++)
				{
					empty = this.getMaterial(afterH + j, afterW, newMaterials);
					trace("type="+empty.type);
					empty.h = empty.h + Direction[direction][0]*-1;
					empty.w = empty.w + Direction[direction][1]*-1;
				}
			}
			var moveTarget:Material = getMaterial(mtr.h, mtr.w, newMaterials);
			moveTarget.h = afterH;
			moveTarget.w = afterW;
			this.resetIndex(newMaterials);
			newMaterials.sortOn("index",Array.NUMERIC);
			return newMaterials;
		}
		
		private function resetIndex(materials:Array):void
		{
			var mask:Array = getMask();
			var index:int = 0;
			for(var i:int = 0; i < H; i ++)
			{
				for(var j:int = 0; j < W; j ++)
				{
					if(mask[i][j])
					{
						continue;
					}
					var mtr:Material = this.getMaterial(i,j,materials);
					if(mtr != null)
					{
						mtr.index = index;
						index ++;
						var h_w:Array = TypeConfig.getH_W(mtr.type);
						for(var k:int = i; k < i + h_w[0]; k ++)
						{
							for(var n:int = j; n < j + h_w[1]; n ++)
							{
								mask[k][n] = true;
							}
						}
					}
				}
			}
		}
		
		private function getMaterial(h:int, w:int, materials:Array):Material
		{
			for each(var o:Material in materials)
			{
				if(o.h == h && o.w == w)
				{
					return o;
				}
			}
//			throw new Error("getMaterial(h:int, w:int, materials:Array):_"+"h="+h+"_w="+w);
			return null;
		}
		
		private function copyMaterials(materials:Array):Array
		{
			var arr:Array = [];
			for(var i:int = 0; i < materials.length; i ++)
			{
				var m:Material = materials[i];
				arr.push(new Material(m.index,m.h,m.w,m.type));
			}
			return arr;
		}
		
		private function traceMaterials(materials:Array):void
		{
			for each(var o:Material in materials)
			{
				trace(o.h + "_" + o.w);
			}
		}
	}
}