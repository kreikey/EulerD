#!/usr/bin/env rdmd -i -I..

import std.stdio;

immutable(int)[len] toImmutStaticArray(size_t len, R)(R range)
{
    import std.algorithm : copy;
    int[len] r;
    copy(range, r[]);
    return r;
}

void main()
{
    import std.range : iota;
    import std.array : staticArray;

    int[int[]] aa;
    immutable(int)[] heapSlice = [0,1];
    aa[heapSlice] = 0;  // OK, aa stores heap allocated key
    writeln(heapSlice.ptr);
    writeln(typeof(heapSlice.ptr).stringof);

    foreach (i; 0..10) {
        auto buffer = 2.iota.toImmutStaticArray!2;
        auto stackSlice = buffer[];
        writeln(stackSlice.ptr);
        writeln(typeof(stackSlice.ptr).stringof);
        writeln(heapSlice.ptr);
        writeln(typeof(heapSlice.ptr).stringof);
        writeln(aa[stackSlice]);
        writeln(aa[heapSlice]);
        aa[stackSlice] = i; // OK yes? only accessing value
    }

    //assert(aa[heapSlice] == 1);
    writeln(aa[[0,1]]);
    auto buffer = 2.iota.staticArray!2;
    auto stackSlice = buffer[];
    aa[cast(immutable(int)[])[0,1]] = 99;
    //aa[buffer] = 5;
    //writeln(aa[heapSlice]);
    writeln(aa[[0,1]]);
    writeln(aa[stackSlice]);
    writeln(aa[heapSlice]);
    heapSlice = [5,5];
    aa[heapSlice] = 50;
    writeln(aa[heapSlice]);
    writeln(aa[cast(immutable(int)[])[5,5]]);
}
