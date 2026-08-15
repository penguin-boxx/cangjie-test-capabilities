// Effects (§8.2): an undeclared, unhandled 'perform' is a missing capability — and unlike an
// exception requirement it is never inferred (§9.1 policy table), so this is an error even though
// the function is not part of the exported surface.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-GetNumber'
// ASSERT: scan Handler<Class-GetNumber>

import stdx.effect.*

class GetNumber <: Command<Int64> {}

// internal and clause-free: an EXCEPTION requirement would be inferred here, an effect one is not
func undeclared(): Int64 {
    return perform GetNumber()
}

main() {
    return 0
}
