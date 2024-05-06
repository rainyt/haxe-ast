package haxe;

import haxe.ast.Tokens;
import haxe.ast.FieldType;
import haxe.ast.BlockExpr;
import haxe.Constraints.Function;
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
	 * Token指令集
	 */
	private var __tokens:Tokens;

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
		var tokens = [];
		var commentMatch = ~/(\/\/.*)|(\/\*[\s\S]*?\*\/)/g;
		var code = commentMatch.map(__hxContent, (f) -> "");
		var haxeMatch = ~/~.+;|("[\s\S]*?")|""|''|('[\s\S]*?')|#[_a-zA-Z0-9]+|[_a-zA-Z0-9]+|=|\.|;|&&|[><!]=|\/\/.+|[{}()!>\/\+-=%<\[\]?:]/g;
		code = haxeMatch.map(code, (f) -> {
			var p = f.matchedPos();
			var pos = new Position(0, p.pos, p.len);
			tokens.push(new Token(f.matched(0), pos));
			return f.matched(0);
		});
		trace(code);
		trace("Token的数量：", tokens.length);
		__tokens = new Tokens(tokens);
		this.parserAts();
	}

	/**
	 * 解析token为Ats
	 */
	private function parserAts():Void {
		while (__tokens.hasNext()) {
			var token = __tokens.readToken();
			switch token.token {
				case PACKAGE:
					var tokens = __tokens.readTokens(END);
					packageName = tokens.getValueByArrayToken();
				case DOT:
				case END:
				case USING:
					var tokens = __tokens.readTokens(END);
					usings.push(Type.resolveClass(tokens.getValueByArrayToken()));
				case IMPORT:
					var tokens = __tokens.readTokens(END);
					imports.push(Type.resolveClass(tokens.getValueByArrayToken()));
				case CLASS:
					className = __tokens.readToken().getValueByToken();
				case LBRACE:
					this.parserFields();
				case RBRACE:
					// 编译结束
					trace("编译结束");
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
		while (__tokens.hasNext()) {
			var token = __tokens.readToken();
			switch token.token {
				case PUBLIC:
					field.access.push(APUBLIC);
				case PRIVATE:
					field.access.push(APRIVATE);
				case FUNCTION:
					// 方法定义读取
					field.name = __tokens.readToken().getValueByToken();
					// 读取参数
					// 将括号读取
					__tokens.readToken();
					var params = readParamArgs();
					var retType:FieldType = null;
					var nextToken = __tokens.readToken(false);
					if (nextToken.token == COLON) {
						// 类型
						__tokens.next();
						retType = TYPE(__tokens.readClass());
						nextToken = __tokens.readToken(false);
					}
					if (nextToken.token == LBRACE) {
						// 开始解析方法
						field.value = readBlock();
					}
					field.type = FUNCTION(null, retType);
				case VAR:
					field.name = __tokens.readToken().getValueByToken();
					// 操作符
					var nextToken = __tokens.readToken();
					if (nextToken.token == COLON) {
						// 绑定了类型
						field.type = TYPE(__tokens.readClass());
					}
					if (__tokens.readToken(false).token == EQUAL) {
						// 赋值处理
						__tokens.next();
						field.value = __tokens.readTokens(END).getValueByArrayToken();
						trace("value is ", field.value);
					}
				case END:
					// 下一个
					this.parserFields();
					break;
				case RBRACE:
					// 结束
					__tokens.last();
					break;
				default:
					// 意外行为
					throw "Token error at " + token.toString();
			}
		}
	}

	/**
	 * 解析方法参数
	 * @return Array<Field>
	 */
	public function readParamArgs():Array<Field> {
		var params = __tokens.readTokens(RPAREN_MIN);
		trace("params=", params);
		var args = [];
		var field:Field = null;
		var i = 0;
		while (i < params.length) {
			if (field == null) {
				field = new Field();
			}
			var token = params[i];
			switch (token.token) {
				case QUESTION:
					// 可选
					field.access.push(AOPTION);
				case COLON:
					// 类型识别
					i++;
					var typeString = params[i].getValueByToken();
					field.type = TYPE(Type.resolveClass(typeString));
				case EQUAL:
					// 默认值
					i++;
					field.value = params[i].getValueByToken();
				default:
					if (field.name == null) {
						field.name = token.getValueByToken();
					} else {
						throw "Token error at " + token.toString();
					}
			}
			i++;
		}
		return args;
	}

	/**
	 * 一个块的token实现
	 * @return BlockExpr
	 */
	public function readBlock():BlockExpr {
		var blockCounts = 0;
		var tokens = [];
		while (__tokens.hasNext()) {
			var token = __tokens.readToken();
			switch token.token {
				case LBRACE:
					blockCounts++;
					if (blockCounts > 1) {
						// 记录
						tokens.push(token);
					}
				case RBRACE:
					blockCounts--;
					if (blockCounts == 0) {
						return new BlockExpr(tokens);
					} else {
						tokens.push(token);
					}
				default:
					tokens.push(token);
			}
		}
		if (tokens.length > 0) {
			throw "Block error. blockCounts=" + blockCounts;
		} else {
			return null;
		}
	}

	
}
