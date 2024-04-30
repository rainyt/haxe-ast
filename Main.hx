import sys.io.File;
import haxe.AST;

class Main {
	/**
	 * 测试用例
	 */
	static function main() {
		var ast = new AST(File.getContent("./src/haxe/AST.hx"));
		test(0, 1);
	}

	static function test(a, b):Void {}
}
