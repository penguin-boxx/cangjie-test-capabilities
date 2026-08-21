// Checked exceptions: `throws ()` is an authoritative empty list -- it pins the callable as requiring
// no capabilities. Combining it with another `throws` clause of the same declaration contradicts the
// pin and is an error, even though several non-empty clauses union freely.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: an empty 'throws' clause cannot be combined with another clause of the same kind

class AException <: Exception {}

func f() throws () throws AException {
    throw AException()
}

func g() throws AException throws () {
    throw AException()
}

main() {
    return 0
}
