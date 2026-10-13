// Section 6.1: checked effects are explicitly enabled independently of exception checking.
// Handler enablement alone is covered by rewrite/compat/axes_off_off.cj.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetNumber'
// ASSERT: scan CanPerform<Class-GetNumber>

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class AException <: Exception {}

func undeclared(): Int64 {
    perform GetNumber() // error: checked effects are explicitly enabled
}

func mayThrow(): Unit throws AException {
    throw AException() // fine: exception checking is off, the clause imposes nothing
}

main() {
    return 0
}
