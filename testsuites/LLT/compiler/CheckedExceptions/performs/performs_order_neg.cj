// Effects (the keyword scheme rule 8): the clause order is fixed — 'performs' precedes 'throws'. The reverse
// order is rejected, not silently accepted.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan must precede

import stdx.effect.*

class GetNumber <: Command<Int64> {}
class MyExc <: Exception {}

func wrongOrder(): Int64 throws MyExc performs GetNumber {
    return 0
}

main() {
    return 0
}
