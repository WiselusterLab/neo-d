module neo.math.vector;

struct Vector
{
	real x = 0.0L;
	real y = 0.0L;
	real z = 0.0L;

	Vector opAdd(in Vector other) const pure nothrow @nogc @safe
	{
		return Vector(x + other.x, y + other.y, z + other.z);
	}

	ref Vector opAddAssign(in Vector other) pure nothrow @nogc @safe
	{
		x += other.x;
		y += other.y;
		z += other.z;

		return this;
	}

	Vector opSub(in Vector other) const pure nothrow @nogc @safe
	{
		return Vector(x - other.x, y - other.y, z - other.z);
	}

	ref Vector opSubAssign(in Vector other) pure nothrow @nogc @safe
	{
		x -= other.x;
		y -= other.y;
		z -= other.z;

		return this;
	}

	real opMul(in Vector other) const pure nothrow @nogc @safe
	{
		return x * other.x + y * other.y + z * other.z;
	}

	Vector opMul(in real scale) const pure nothrow @nogc @safe
	{
		return Vector(x * scale, y * scale, z * scale);
	}

	ref Vector opMulAssign(in real scale) pure nothrow @nogc @safe
	{
		x *= scale;
		y *= scale;
		z *= scale;

		return this;
	}

	Vector opMod(in Vector other) const pure nothrow @nogc @safe
	{
		return Vector(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);
	}

	ref Vector opModAssign(in Vector other) pure nothrow @nogc @safe
	{
		auto xn = y * other.z - z * other.y;
		auto yn = z * other.x - x * other.z;
		auto zn = x * other.y - y * other.x;

		x = xn;
		y = yn;
		z = zn;

		return this;
	}

	Vector opPos() const pure nothrow @nogc @safe
	{
		return this;
	}

	Vector opNeg() const pure nothrow @nogc @safe
	{
		return Vector(-x, -y, -z);
	}

	real opStar() const pure nothrow @nogc @safe
	{
		return (x ^^ 2 + y ^^ 2 + z ^^ 2) ^^ 0.5L;
	}

	string toString() const @safe
	{
		import std.format : format;

		return format("(%s, %s, %s)", x, y, z);
	}
}

@safe unittest
{
	import std.stdio : writeln;

	immutable a = Vector(3, 4, 0.5);
	auto b = Vector(5, -1, 2);

	writeln;
	writeln("Unit test in " ~ __MODULE__ ~ ":");

	writeln("a = ", a);
	writeln("b = ", b);
	writeln("a + b = ", a + b);
	writeln("a - b = ", a - b);
	writeln("a * b = ", a * b);
	writeln("a * 2 = ", a * 2);
	writeln("0.3 * a = ", 0.3 * a);
	writeln("a % b = ", a % b);
	writeln("+a = ", +a);
	writeln("-a = ", -a);
	writeln("*a = ", *a);

	writeln;
}
