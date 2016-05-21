package mmo.tree
{
	public class Node
	{
		private var _childs:Array = [];
		private var _parent:Node;
		private var _key:int;
		
		public function Node(key:int, parent:Node)
		{
			this._key = key;
			this._parent = parent;
		}
		
		public function addChild(node:Node):void
		{
			this._childs.push(node);
		}
		
		public function get parent():Node
		{
			return _parent;
		}
		
		public function get key():int
		{
			return _key;
		}
	}
}