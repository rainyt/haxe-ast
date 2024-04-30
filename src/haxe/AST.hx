package haxe;

import haxe.ast.Token;

/**
 * Haxe树解析器
 */
class AST {
	/**
	 * Haxe 源码
	 */
	private var __hxContent:String;

	/**
	 * Token 数组
	 */
	private var __tokens:Array<Token> = [];

	/**
	 * 构造一个AST解析器
	 * @param hxContent Haxe源码
	 */
	public function new(hxContent:String) {
		this.__hxContent = hxContent;
		this.parserTokens();
	}

	/**
	 * 解析源码为Token数组
	 */
	private function parserTokens():Void {
		// 注释正则 /\*[^]+\*/|//.+
		trace("测试换行啊
        ?
        换行了");
		var commentMatch = ~/(\/\/.*)|(\/\*[\s\S]*?\*\/)/g;
		var code = commentMatch.map(__hxContent, (f) -> "");
		var haxeMatch = ~/~.+;|("[\s\S]*?")|""|''|('[\s\S]*?')|#[_a-zA-Z0-9]+|[_a-zA-Z0-9]+|=|\.|;|&&|[><!]=|\/\/.+|[{}()!>\/\+-=%<\[\]?:]/g;
		code = haxeMatch.map(code, (f) -> {
			trace(f.matched(0));
			__tokens.push(new Token(f.matched(0)));
			return "^" + f.matched(0) + "^";
		});
		trace(code);
		trace("Token的数量：", __tokens.length);
	}
}
