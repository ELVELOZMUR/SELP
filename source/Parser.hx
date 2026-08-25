using StringTools;

class Parser {
	static var index:Int;

	public static function parseFile(text:String):Map<String, String> {
		var map = new Map<String, String>();

		var buffer = new StringBuf();

		var key:String = "";

		index = 0;
		var char:Int;
		var inKey = true;
		while (index != text.length) {
			char = text.fastCodeAt(index);

			switch (char) {
				case "/".code:
					if (index + 1 < text.length) {
						if (text.fastCodeAt(index + 1) == "/".code) {
							skipUntilBreak(text);
							continue;
						}
					}
				case "-".code:
					if (index + 1 < text.length) {
						if (text.fastCodeAt(index + 1) == "-".code) {
							skipUntilBreak(text);
							continue;
						}
					}
				case ":".code | "=".code:
					if (inKey) {
						inKey = false;
						key = buffer.toString();
						buffer = new StringBuf();
						index++;
						continue;
					}
				case "\n".code:
					map.set(key, buffer.toString());
					key = "";
					buffer = new StringBuf();
					inKey = true;
					index++;
					continue;
				case "\r".code:
					// gets ignored
                case "\t".code:
                    //gets ignored
				case "\\".code:
					if (index + 1 < text.length) {
						var followChar = text.fastCodeAt(index + 1);

						switch (followChar) {
							case "n".code:
								buffer.addChar("\n".code);
								index++;
								continue;
							case "t".code:
								buffer.addChar("\t".code);
								index++;
								continue;
							case "r".code:
								buffer.addChar("\r".code);
								index++;
								continue;
						}
					}
			}

			buffer.addChar(char);
			index++;
		}

		if (buffer.length != 0 && key.length != 0)
			map.set(key, buffer.toString());

		return map;
	}

	// quickest way to skip all text until a \n
	static function skipUntilBreak(text:String) {
		while (index < text.length) {
			var char = text.fastCodeAt(index);
			if (char == "\n".code) {
				index++;
				return;
			}

			index++;
		}
	}
}
