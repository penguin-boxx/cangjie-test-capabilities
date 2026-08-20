// Checked exceptions (overriding and redefinition): an override may not require capabilities the
// original does not provide for.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: exception type 'Class-BException' in 'throws' clause of 'm' is not covered by the overridden or implemented declaration

class AException <: Exception {}
class BException <: Exception {}

open class P {
    public open func m(): Unit throws AException {
        throw AException()
    }
}

class C1 <: P {
    // BException is not a subtype of any entry in P.m's list
    public override func m(): Unit throws AException, BException {
        throw BException()
    }
}

main() {
    return 0
}
