module neo.container.stack;

import core.memory : GC;
import core.stdc.stdlib : free, malloc;
import core.stdc.stdio : fprintf, stderr;

struct Stack(E)
{
    private static struct Node
    {
        E value;
        Node* next;

        nothrow @nogc @trusted new(size_t sz)
        {
            void* ptr = malloc(sz);
            GC.addRange(ptr, sz);

            debug
                fprintf(stderr, "New: <%p>\n", ptr);

            return ptr;
        }

        nothrow @nogc @trusted delete(void* ptr)
        {
            free(ptr);
            GC.removeRange(ptr);

            debug
                fprintf(stderr, "Delete: <%p>\n", ptr);
        }
    }

    private Node* _top;
    private size_t _size;

    @disable this(Node*, size_t);

    nothrow @nogc @safe this(this)
    {
        _top = new Node(_top.value, _top.next);

        for (auto node = _top; node.next; node = node.next)
            node.next = new Node(node.next.value, node.next.next);
    }

    nothrow @nogc @safe ~this()
    {
        while (_top)
            uncheckedPop();
    }

    @property nothrow @nogc @safe const bool empty()
    {
        return !_top;
    }

    @property nothrow @nogc @safe const size_t size()
    {
        return _size;
    }

    @property nothrow @nogc @safe inout inout(E)* top()
    {
        return _top ? &_top.value : null;
    }

    nothrow @nogc @safe void pop()
    {
        if (!_top)
            return;
 
        uncheckedPop();
        --_size;
    }

    nothrow @nogc @safe void push(in E value)
    {
        _top = new Node(value, _top);
        ++_size;
    }

    private nothrow @nogc @safe void uncheckedPop()
    {
        auto node = _top;
        _top = _top.next;
        delete node;
    }
}

@safe unittest
{
    import std.stdio : writeln;

    Stack!int s;

    foreach (i; 0 .. 10)
        s.push(i);

	writeln(s.size);

    while (!s.empty)
    {
        writeln(*s.top());
        s.pop();
    }
}
