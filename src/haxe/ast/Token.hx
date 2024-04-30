package haxe.ast;

/**
 * 语法树节点Token
 */
class Token {
	/**
	 * Token字符
	 */
	public var token:TokenType;

	/**
	 * 坐标
	 */
	public var pos:Position;

	public function new(token:String, pos:Position) {
		this.token = token;
		this.pos = pos;
	}

	public function toString():String {
		return "Token{token=\"" + token + "\", pos=" + pos + "}";
	}
}
