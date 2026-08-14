// Guard: WITHOUT --enable-chexc, `throws`-clause syntax is not available;
// a declaration using it must fail to compile.

// EXEC-PIPE-1: %compiler %cmp_opt %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error

class AException <: Exception {}

func f() throws AException {
    throw AException()
}

main() {
    return 0
}
