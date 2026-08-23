// Checked exceptions (which declarations are inferred): an override or implementation is checked
// against the overridden declaration's list whether its own list is written or inferred. An inferred
// override requiring more than the overridden list is an error -- a list depends on its own body
// only, never on its overriders. Written lists are compared during type check; an inferred one is
// compared after inference, which is what this pins.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: exception type 'Class-AException' in 'throws' clause of 'run' is not covered
// ASSERT: scan error: exception type 'Class-AException' in 'throws' clause of 'act' is not covered

class AException <: Exception {}
class BException <: Exception {}

open class Base {
    public open func run(): Unit
    throws BException {
        throw BException()
    }
}

class Derived <: Base {
    // no clause of its own, so the list is inferred -- and it exceeds Base's
    public override func run(): Unit {
        throw AException()
    }
}

interface Contract {
    func act(): Unit
    throws BException
}

class Impl <: Contract {
    // implementations are checked the same way
    public func act(): Unit {
        throw AException()
    }
}

main() {
    return 0
}
