// Effects (keyword scheme rule 9): in FUNCTIONAL TYPES the pre-arrow clause sequence is one
// grammar production and 'performs' precedes 'throws' — the reverse order is rejected there. On
// DECLARATIONS the 'where', 'performs' and 'throws' blocks order freely, which
// 'performs_order_free.cj' pins; this test keeps the functional-type half.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan must precede

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class MyExc <: Exception {}

// A functional type: 'performs' must come first, so this is rejected.
func takesCallback(f: (Int64) throws MyExc performs GetNumber -> Int64): Int64 {
    return 0
}

main() {
    return 0
}
