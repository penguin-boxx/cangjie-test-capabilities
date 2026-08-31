// Effect requirements are never inferred -- every 'performs' list is written -- so the '...' marker,
// which opens an exception list to inference, has nothing to open on a 'performs' clause.

// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '...' is not allowed in a 'performs' clause

import stdx.effect.*

class GetNumber <: Command<Int64> {}

func f(): Int64
performs GetNumber, ... {
    perform GetNumber()
}

main() {
    return 0
}
