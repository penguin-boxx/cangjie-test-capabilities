// Checked exceptions (capability parameters in declarations/capability argument inference): the positive twin of prop_accessor_demand_neg — the same
// accesses are fine once the capabilities are supplied, either by a try-catch or by the
// caller's own clause. Guards against over-demanding.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class GException <: Exception {}
class SException <: Exception {}

public class C {
    var store: Int64 = 0

    public mut prop p: Int64 {
        get() throws GException {
            if (store < 0) {
                throw GException()
            }
            store
        }
        set(x) throws SException {
            if (x < 0) {
                throw SException()
            }
            store = x
        }
    }
}

// discharged by a try-catch
public func handled(c: C): Int64 {
    try {
        c.p = 3
        c.p += 1
        c.p
    } catch (e: GException) {
        0
    } catch (e: SException) {
        0
    }
}

// propagated through the caller's own clause
public func propagated(c: C): Int64 throws GException, SException {
    c.p++
    c.p
}

main() {
    let c = C()
    if (handled(c) != 4) {
        return 1
    }
    try {
        if (propagated(c) != 5) {
            return 1
        }
    } catch (e: Exception) {
        return 1
    }
    return 0
}
