// Effect requirements follow the effect-handler feature, on an axis of its own: wherever that
// feature is enabled, a 'perform' with no handler is an error at every exception-checking level --
// there is no migration level for it, since an unhandled 'perform' fails at run time. Exception
// requirements, in the same compilation, impose nothing while checking is off.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetNumber'
// ASSERT: scan CanPerform<Class-GetNumber>

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class AException <: Exception {}

func undeclared(): Int64 {
    perform GetNumber() // error: effects are checked whenever handlers are enabled
}

func mayThrow(): Unit throws AException {
    throw AException() // fine: exception checking is off, the clause imposes nothing
}

main() {
    return 0
}
