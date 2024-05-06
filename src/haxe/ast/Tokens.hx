package haxe.ast;

using haxe.ast.TokenTools;

class Tokens {
	/**
	 * Token 数组
	 */
	private var __tokens:Array<Token> = [];

	/**
	 * Token 索引
	 */
	private var __tokenIndex:Int = 0;

	public function new(tokens:Array<Token>) {
		this.__tokens = tokens;
	}

	/**
	 * 读取Token
	 */
	public function readToken(tokenAdd = true):Token {
		var token = __tokens[__tokenIndex];
		if (tokenAdd)
			__tokenIndex++;
		return token;
	}

	/**
	 * 读取仅接受的Token，直到结束Token后返回
	 * @param tokenTypes 
	 * @param end 
	 * @return Array<Token>
	 */
	public function readTokens(?tokenTypes:Array<TokenType>, ?end:TokenType):Array<Token> {
		var tokens = [];
		while (__tokenIndex < __tokens.length) {
			var token = readToken();
			if (token.token == end && readToken(false).token != end) {
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
	 * 存在下一个指令集时
	 * @return Bool
	 */
	public function hasNext():Bool {
		return __tokenIndex < __tokens.length;
	}

	/**
	 * 下一个
	 */
	public function next():Void {
		__tokenIndex++;
	}

	/**
	 * 回到上一个
	 */
	public function last():Void {
		__tokenIndex--;
	}

	/**
	 * 获得一个类型
	 */
	public function readClass():Class<Dynamic> {
		var className = readToken().getValueByToken();
		var nextToken = readToken(false);
		if (nextToken.token == LESS) {
			__tokenIndex++;
			readTokens(GREATER);
		}
		return Type.resolveClass(className);
	}
}
