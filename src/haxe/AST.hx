package haxe;

import haxe.ast.Field;
import haxe.ast.TokenType;
import haxe.ast.Position;
import haxe.ast.Token;

using haxe.ast.TokenTools;

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
	 * Token 索引
	 */
	private var __tokenIndex:Int = 0;

	/**
	 * 包名
	 */
	public var packageName:String = "";

	/**
	 * 类名
	 */
	public var className:String;

	/**
	 * 导入的类型
	 */
	public var imports:Array<Class<Dynamic>> = [];

	/**
	 * 使用的类型
	 */
	public var usings:Array<Class<Dynamic>> = [];

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
			var p = f.matchedPos();
			var pos = new Position(0, p.pos, p.len);
			__tokens.push(new Token(f.matched(0), pos));
			return f.matched(0);
		});
		trace(code);
		trace("Token的数量：", __tokens.length);
		this.parserAts();
	}

	/**
	 * 读取Token
	 */
	private function readToken():Token {
		var token = __tokens[__tokenIndex];
		__tokenIndex++;
		return token;
	}

	/**
	 * 读取仅接受的Token，直到结束Token后返回
	 * @param tokenTypes 
	 * @param end 
	 * @return Array<Token>
	 */
	private function readTokens(?tokenTypes:Array<TokenType>, ?end:TokenType):Array<Token> {
		var tokens = [];
		while (__tokenIndex < __tokens.length) {
			var token = readToken();
			if (token.token == end) {
				break;
			}
			if (tokenTypes != null && tokenTypes.indexOf(token.token) == -1) {
				break;
			}
			tokens.push(token);
		}
		return tokens;
	}

	/**
	 * 解析token为Ats
	 */
	private function parserAts():Void {
		while (__tokenIndex < __tokens.length) {
			var token = readToken();
			switch token.token {
				case PACKAGE:
					var tokens = readTokens(END);
					packageName = tokens.getValueByArrayToken();
				case DOT:
				case END:
				case USING:
					var tokens = readTokens(END);
					usings.push(Type.resolveClass(tokens.getValueByArrayToken()));
				case IMPORT:
					var tokens = readTokens(END);
					imports.push(Type.resolveClass(tokens.getValueByArrayToken()));
				case CLASS:
					className = this.readToken().getValueByToken();
				case LBRACE:
					this.parserFields();
				default:
					// 意外行为
					throw "Token error at " + token.toString();
			}
		}
	}

	/**
	 * 解析定义、方法等
	 */
	private function parserFields():Void {
		var field = new Field();
		while (__tokenIndex < __tokens.length) {
			var token = this.readToken();
			switch token.token {
				case PRIVATE:
				default:
					// 意外行为
					throw "Token error at " + token.toString();
			}
		}
	}
}
