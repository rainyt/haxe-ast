package haxe.ast;

enum abstract Access(String) {
	/**
	 * 私有
	 */
	var APRIVATE = "private";

	/**
	 * 公开
	 */
	var APUBLIC = "public";

	/**
	 * 静态
	 */
	var ASTATIC = "static";

	/**
	 * 可选
	 */
	var AOPTION = "option";
}
