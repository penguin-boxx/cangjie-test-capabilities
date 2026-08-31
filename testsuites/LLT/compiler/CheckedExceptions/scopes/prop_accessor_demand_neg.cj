// Checked exceptions (capability parameters in declarations/capability argument inference): a property accessor's `throws` clause is demanded at every
// use site — read, write, compound assign and increment — not only inside the accessor body.
// The accessors are public so inference cannot mask the result.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GException'
// ASSERT: scan Cannot find a capability for 'Class-SException'

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

public func read(c: C): Int64 {
    c.p // demands GException
}

public func write(c: C): Unit {
    c.p = 1 // demands SException
}

public func bump(c: C): Unit {
    c.p++ // demands both
}

public func plus(c: C): Unit {
    c.p += 1 // demands both
}

main() {
    return 0
}
