package haxe.ast;

/**
 * 定义字段，可以是方法、变量
 */
class Field {
	/**
	 * 访问权限
	 */
	public var access:Array<Access> = [];

	/**
	 * 定义变量名
	 */
	public var name:String;

	/**
	 * 值定义
	 */
	public var value:Dynamic;

	/**
	 * 类型
	 */
	public var type:Class<Dynamic>;

	public function new() {}
}
