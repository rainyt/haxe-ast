package haxe.ast;

/**
 * 源码位置
 */
class Position {
	/**
	 * 所在的行数
	 */
	public var line:Int;

	/**
	 * 所在的列数
	 */
	public var pos:Int;

	/**
	 * 有问题的Token的长度
	 */
	public var len:Int;

	public function new(line:Int, pos:Int, len:Int) {
		this.line = line;
		this.pos = pos;
		this.len = len;
	}

	public function toString():String {
		return "line: " + line + ", pos: " + pos + ", len: " + len;
	}
}
