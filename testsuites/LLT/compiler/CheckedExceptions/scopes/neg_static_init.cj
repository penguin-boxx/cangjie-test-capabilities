// Checked exceptions (capability scopes): no capability scope encloses a static initializer. A
// 'static init' block runs during global initialization, exactly as a static field initializer
// does -- no handler of the program's own is installed there, and there is no call site at which
// an inferred list could be paid -- so it is not inference-eligible, like a finalizer, and a
// checked requirement inside it is reported where it arises. The clause side of the rule is in
// parse/neg_static_init_clause.cj.
//
// Before, a 'static init' block was inference-eligible: its requirements were quietly inferred into
// a list nothing ever pays, none of the three blocks below was reported at 'error', and at run time
// the exception escaped from the global initializer. The static field initializer on line 39 was
// already rejected; it is here as the control.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan neg_static_init.cj:27:9:
// ASSERT: scan neg_static_init.cj:34:13:
// ASSERT: scan neg_static_init.cj:39:27:
// ASSERT: scan neg_static_init.cj:46:9:
// ASSERT: scan Cannot find a capability for 'Class-AException'

open class AException <: Exception {}

func throwing(): Int64 throws AException { throw AException() }

class Thrower {
    static var y: Int64 = 0
    static init() {
        throw AException()          // error: nothing encloses a static initializer
    }
}

class Caller {
    static var y: Int64 = 0
    static init() {
        y = throwing()              // error: the call's requirement has no supplier
    }
}

class Control {
    static let z: Int64 = throwing() // error, as before: a static field initializer
}

class Capturing captures AException {
    init() {}
    static var y: Int64 = 0
    static init() {
        throw AException()          // error: the captured capability needs a receiver
    }
}

main(): Int64 {
    return 0
}
