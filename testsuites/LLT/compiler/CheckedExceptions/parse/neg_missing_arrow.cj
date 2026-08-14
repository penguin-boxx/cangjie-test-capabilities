// Checked exceptions (§3.4): a functional type's `throws` clause must be followed
// by `->`; `(A) throws (E)` without an arrow is a parse error.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: expected '->' after 'throws' clause in function type

class AException <: Exception {}

var f: (Int64) throws (AException) = 0

main() {
    return 0
}
