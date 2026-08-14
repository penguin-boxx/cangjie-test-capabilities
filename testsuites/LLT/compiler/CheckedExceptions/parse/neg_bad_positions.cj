// Checked exceptions (§3.2): `throws` clauses are only legal on callables —
// not on variable declarations.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: expected ';' or '<NL>', found 'throws'

class AException <: Exception {}

var x: Int64 throws AException = 0

main() {
    return 0
}
