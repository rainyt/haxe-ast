package haxe.ast;

class TokenTools {
	/**
	 * 通过数组Token获取字符串
	 * @param tokens 
	 * @return String
	 */
	public static function getValueByArrayToken(tokens:Array<Token>):String {
		var value = "";
		for (token in tokens) {
			value += token.token;
		}
		return value;
	}

	/**
	 * 通过Token获取字符串
	 * @param token 
	 * @return String
	 */
	public static function getValueByToken(token:Token):String {
		return token.token;
	}
}
