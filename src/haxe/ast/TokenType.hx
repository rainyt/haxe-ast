package haxe.ast;

/**
 * Token类型
 */
enum abstract TokenType(String) to String from String {
	/**
	 * 包名
	 */
	var PACKAGE = "package";

	/**
	 * .
	 */
	var DOT = ".";

	/**
	 * 结束符
	 */
	var END = ";";

	/**
	 * import
	 */
	var IMPORT = "import";

	/**
	 * using
	 */
	var USING = "using";

	/**
	 * class
	 */
	var CLASS = "class";

	/**
	 * {
	 */
	var LBRACE = "{";

    /**
     * }
     */
    var RBRACE = "}";

    /**
     * private
     */
    var PRIVATE = "private";
}
