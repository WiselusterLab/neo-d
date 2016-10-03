module neo.util.datetime;

struct DateTime
{
	import core.stdc.time : localtime, strftime, time, tm;
	import std.format : FormatException, FormatSpec;

	private tm _data;

	private const void toString(void delegate(const(char)[]) sink, const(char)[] fmt)
	{
		import core.stdc.string : strlen;

		auto buf = new char[256];
		auto ptr = (fmt ~ '\0').ptr;
		size_t len;

		foreach (n; 0 .. 4)
		{
			strftime(buf.ptr, buf.length, ptr, &_data);

			if ((len = buf.ptr.strlen) < buf.length)
				break;

			buf.length *= 2;
		}

		if (sink)
			sink(buf[0 .. len]);
	}

	const string toString()
	{
		string ret;

		toString(s => cast(void) (ret = s.idup), "%c");

		return ret;
	}

	const void toString(void delegate(const(char)[]) sink, ref FormatSpec!char fmt)
	{
		import std.regex : matchFirst, regex;

		auto str = ['%', fmt.spec];

		if (fmt.spec == 'E' || fmt.spec == 'O')
		{
			str ~= fmt.trailing[0];
			fmt.trailing = fmt.trailing[1 .. $];
		}

		if (str.matchFirst(`%(E?[CXYcxy]|O?[IMSUVWdemuwy]|[ABCDFGHIMRSTUVWXYZabcdeghjmnptuwxyz])`.regex).empty)
			throw new FormatException("Incorrect format specifier " ~ str.idup ~ " for " ~ __MODULE__ ~ "." ~ DateTime.stringof);

		toString(sink, str);
	}

	pure nothrow @safe @nogc const tm toTM()
	{
		return _data;
	}

	static nothrow DateTime now()
	{
		auto t = time(null);

		return DateTime(*localtime(&t));
	}
}

unittest
{
	import std.stdio : writefln;

	"%1$F %1$T".writefln(DateTime.now);
}
