package mmo
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mmo.config.TypeConfig;
	import mmo.data.Material;
	import mmo.tree.Node;
	import mmo.type.TypeBase;
	import mmo.type.Type_00;
	import mmo.type.Type_11;
	import mmo.type.Type_12;
	import mmo.type.Type_22;
	
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
		
		private var _gameOver:Boolean = false;
		
		private var _root:Node;
		
		private var _show:String = "44401109_44414273_44414276_44414228_44381780_10909268_10909205_44381717_44413973_44414021_44413253_" +
			"44348741_44152133_44152145_44348753_44413265_44414033_44414036_44413268_44348756_44152148_44151893_44348501_44347733_" +
			"44151125_44086613_42513749_36222293_11056469_11194709_44618069_44765525_42651989_42653009_44766545_44778833_44225873_" +
			"44224853_44777813_44762453_44221781_42120533_42648917_42652757_44766293_44778581_44225621_44095829_42522965_42584405_" +
			"42588245_43571285_43632725_43595861_10123349_9989717_35155541_38301269_34172501_35204693_39333461_39559253_39559505_" +
			"39559508_39560276_39560528_39552404_39036308_38249876_35104148_35103893_38249621_39036053_39552149_39551381_39035285_" +
			"38248853_35103125_35104145_38249873_39036305_39552401_39560516_39560468_39528788_5957972_18540884_21686612_21678437_" +
			"18532709_5949797_39520613_39552389_39036293_38249861_35104133_35096933_38242661_39029093_5433701_18016613_17230181_" +
			"4647269_17230181";
		
		private var _showMapInts:Array;
		private var _mapStr:String = "";
		private var _mapContainer:MovieClip;
		
		public function KlotskiPanel()
		{
			super();
//			_mapStr = "01#11#01#10#10#01#01#10#01#01#10#00#00"; //地图1
			_mapStr = "01#00#00#01#10#11#10#10#01#01#10#01#01"; //地图2
//			_mapStr = "01#01#11#10#00#00#10#01#10#01#10#01#01"; //地图3
//			_mapStr = "01#10#01#10#01#01#01#11#01#10#10#00#00"; //地图4
//			_mapStr = "01#11#01#10#10#00#00#10#01#01#10#01#01"; //地图5
			this._mapContainer = this.getChildByName("mccontainer") as MovieClip;
			
			this._mapStr = _mapStr.replace(/#/g,"");
			this._mapInt = parseInt(_mapStr,2);
			this.setMap();
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "btnauto":
					this.auto();
					break;
			}
		}
		
		private function auto():void
		{
			this._root = new Node(_mapInt, null);
//			this._mapInt = 44401109;
			trace("init int="+_mapInt);
//			this.setMap();
			this.getWays(_materials, _root);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			var mapInt:int = int(_showMapInts.pop());
			trace(mapInt);
			if(mapInt != 0)
			{
				this.showMap(mapInt);
			}else
			{
				var t:Timer = e.currentTarget as Timer;
				t.stop();
				trace("结束了");
			}
			
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
				this._mapContainer.addChild(mc);
				this._items.push(mc);
				this._materials.push(material);
			}
		}
		
		private function showMap(mapInt:int):void
		{
			this.clearStage();
			var mask:Object = {};
			var stand:int = 3; //11
			for(var i:int = 0; i < PosNum; i ++)
			{
				var b:int = stand << (TotalPos - (i + 1)*2);
				var type:int = (mapInt & b)>>(TotalPos - (i + 1)*2);
				var h_w:Array = getH_W(type, mask);
				var mc:TypeBase;
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
				this._mapContainer.addChild(mc);
			}
		}
		
		private function clearStage():void
		{
			while(this._mapContainer.numChildren > 0)
			{
				this._mapContainer.removeChildAt(0);
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
		
		private function getWays(materials:Array, node:Node):void
		{
			if(this._gameOver)
			{
				return;
			}
			if(checkIsWin(materials))
			{
				trace(getMapInt(materials) +"___获胜地图");
				this._gameOver = true;
				this.traceResult(node);
				return;
			}
			for each(var o:Material in materials)
			{
				var results:Array = checkCanMove(o, materials);
				if(results != null)
				{
					for(var i:int = 0; i < results.length; i ++)
					{
						var mtrs:Array = results[i];
						var mapInt:int = getMapInt(mtrs);
						if(!_alreadyKey[mapInt])
						{
							this._alreadyKey[mapInt] = true;
							this._rightKey.push(mapInt);
							var childNode:Node = new Node(mapInt, node);
							node.addChild(childNode);
							getWays(mtrs, childNode);
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
//				trace("type="+materials[i].type + "_h="+materials[i].h + "_w="+materials[i].w + "_index="+materials[i].index);
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
					var posH:int = afterH;
					if(d == DIRECTION_DOWN && h_w[0] >= 2)
					{
						posH += 1;
					}
					for(var i:int = 0; i < n; i ++)
					{
						pos.push([posH,afterW + i]);
					}
				}else
				{
					n = h_w[0];
					var posW:int = afterW;
					if(d == DIRECTION_RIGHT && h_w[1] >= 2)
					{
						posW += 1;
					}
					for(var j:int = 0; j < n; j ++)
					{
						pos.push([afterH + j, posW]);
					}
				}
				var isOutSide:Boolean = false;
				for each(var p:Array in pos)
				{
					if(p[0] < 0 || p[0] >= H || p[1] < 0 || p[1] >= W)
					{
						isOutSide = true;
					}
				}
				if(isOutSide)
				{
					continue;
				}
				
				var canMove:Boolean = false;
				var hitNum:int = 0;
				for(var k:int = 0; k < pos.length; k ++)
				{
					for each(var o:Material in emptys)
					{
						if(pos[k][0] == o.h && pos[k][1] == o.w)
						{
							hitNum ++;
						}
					}
					if(hitNum >= n)
					{
						canMove = true;
					}
				}
				if(canMove)
				{
					var newMaterial:Array = this.genNewMaterials(mtr,d,materials);
					materialsResult.push(newMaterial);
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
			
			var emptysss:Array = this.getEmptyPos(newMaterials);
			
			var moveTarget:Material = getMaterial(mtr.h,mtr.w,newMaterials);
			
			var afterH:int = mtr.h + Direction[direction][0];
			var afterW:int = mtr.w + Direction[direction][1];
			
			var h_w:Array = TypeConfig.getH_W(mtr.type);
			var pos:Array = [];
			var n:int;
			var empty:Material;
			
			if(direction == DIRECTION_UP || direction == DIRECTION_DOWN)
			{
				n = h_w[1];
				var preEmptyH:int = afterH;
				if(h_w[0] >= 2 && direction == DIRECTION_DOWN)
				{
					preEmptyH ++;
				}
				
				for(var i:int = 0; i < n; i ++)
				{
					empty = this.getMaterial(preEmptyH, afterW + i,newMaterials);
					var afterEmptyH:int = mtr.h;
					if(h_w[0] >= 2)
					{
						if(direction == DIRECTION_UP)
						{
							afterEmptyH ++;
						}
					}
					empty.h = afterEmptyH;
					empty.w = mtr.w + i;
				}
			}else
			{
				n = h_w[0];
				var preEmptyW:int = afterW;
				if(h_w[1] >= 2 && direction == DIRECTION_RIGHT)
				{
					preEmptyW ++;
				}
				
				for(var j:int = 0; j < n; j ++)
				{
					empty = this.getMaterial(afterH + j, preEmptyW,newMaterials);
					var afterEmptyW:int = mtr.w;
					if(h_w[1] >= 2)
					{
						if(direction == DIRECTION_LEFT)
						{
							afterEmptyW ++;
						}
					}
					empty.h = mtr.h + j;
					empty.w = afterEmptyW;
				}
			}
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
		
		private function checkIsWin(materials:Array):Boolean
		{
			for each(var o:Material in materials)
			{
				if(o.type == TypeConfig.TYPE_2_2 && o.h == 3 && o.w == 1)
				{
					return true;
				}
			}
			return false;
		}
		
		private function traceMaterials(materials:Array):void
		{
			for each(var o:Material in materials)
			{
				trace(o.h + "_" + o.w + "_type="+o.type);
			}
		}
		
		private function traceResult(node:Node):void
		{
			var str:String = "";
			while(node)
			{
				str += node.key + "_";
				node = node.parent;
			}
			trace("results:"+str);
			this._show = str;
			this._showMapInts = _show.split("_");
			this._showMapInts.pop();
			trace("步数:"+_showMapInts.length);
			var t:Timer = new Timer(200);
			t.addEventListener(TimerEvent.TIMER, onTimer);
			t.start();
		}
	}
}