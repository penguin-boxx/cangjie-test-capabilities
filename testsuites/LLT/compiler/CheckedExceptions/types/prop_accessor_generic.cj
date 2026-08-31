// Checked exceptions: an accessor clause naming a class type parameter is demanded at the
// INSTANTIATED type. The `D <: P<Int64>` shape means the mapping must come from the receiver's
// type (walking the inheritance chain), not from the accessor's owner.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class MyExc<T> <: Exception {}

public open class P<T> {
    public prop q: Int64 {
        get() throws MyExc<T> {
            0
        }
    }
}

public class D <: P<Int64> {}

// the demand is MyExc<Int64>, so this handler discharges it
public func ok(d: D): Int64 {
    try {
        d.q
    } catch (e: MyExc<Int64>) {
        1
    }
}

main() {
    if (ok(D()) != 0) {
        return 1
    }
    return 0
}
