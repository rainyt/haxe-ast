package haxe.ast;

enum FieldType {
	TYPE(c:Class<Dynamic>);
	FUNCTION(args:Array<Dynamic>, returnType:FieldType);
}
