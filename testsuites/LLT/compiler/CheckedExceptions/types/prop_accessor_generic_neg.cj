// Checked exceptions: the instantiated demand must be exactly MyExc<Int64> — a handler for a
// different instantiation does not discharge it (generics are monomorphized, so MyExc<String>
// and MyExc<Int64> are distinct classes).

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-MyExc<Int64>'

class MyExc<T> <: Exception {}

public open class P<T> {
    public prop q: Int64 {
        get() throws MyExc<T> {
            0
        }
    }
}

public class D <: P<Int64> {}

public func bad(d: D): Int64 {
    try {
        d.q // demands MyExc<Int64>
    } catch (e: MyExc<String>) {
        1
    }
}

main() {
    return 0
}
