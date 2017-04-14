module neo.container.stack;

import core.memory : GC;
import core.stdc.stdlib : free, malloc;

debug (NeoD)
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
            debug (NeoD)
                fprintf(stderr, "New node of " ~ E.stringof ~ ": <%p>\n", ptr);
            return ptr;
        }

        nothrow @nogc @trusted delete(void* ptr)
        {
            free(ptr);
            GC.removeRange(ptr);
            debug (NeoD)
                fprintf(stderr, "Delete node of " ~ E.stringof ~ ": <%p>\n", ptr);
        }
    }

    private Node* _top;
    private size_t _size;

    @disable this(Node*, size_t);

    nothrow @nogc @safe this(E[] values...)
    {
        foreach (value; values)
            _top = new Node(value, _top);
        _size = values.length;
    }

    nothrow @nogc @safe this(this)
    {
        _top = new Node(_top.value, _top.next);
        for (Node* node = _top; node.next; node = node.next)
            node.next = new Node(node.next.value, node.next.next);
    }

    nothrow @nogc @safe ~this()
    {
        clear();
    }

    @property const bool empty()
    {
        return !_top || !_size;
    }

    @property const size_t size()
    {
        return _size;
    }

    @property inout inout(E)* top()
    {
        return empty ? null : &_top.value;
    }

    nothrow @nogc @safe void clear()
    {
        Node* node;
        while (!empty)
        {
            node = _top;
            _top = _top.next;
            delete node;
        }
        _size = 0;
    }

    nothrow @nogc @safe void pop()
    {
        if (empty)
            return;
        Node* node = _top;
        _top = _top.next;
        delete node;
        --_size;
    }

    nothrow @nogc @safe void push(E value)
    {
        _top = new Node(value, _top);
        ++_size;
    }
}

Stack!E makeStack(E)(E[] values...)
{
    return Stack!E(values);
}

@safe unittest
{
    import std.stdio : writeln;

    Stack!int s = makeStack(0, 1);
    s.clear();
    foreach (i; 0 .. 10)
        s.push(i);
    writeln(s.size);
    while (!s.empty)
    {
        writeln(*s.top);
        s.pop();
    }
}
