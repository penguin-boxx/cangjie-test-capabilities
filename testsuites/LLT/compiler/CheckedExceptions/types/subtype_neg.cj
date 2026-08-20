// Checked exceptions (functional types): narrowing a capability list is NOT a subtype —
// the target type must cover every capability the source function requires.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: mismatched types
// ASSERT: scan expected '() throws (Class-AException) -> Unit', found '() throws (Class-AException, Class-BException) -> Nothing'

class AException <: Exception {}
class BException <: Exception {}

func f() throws AException, BException {
    throw AException()
}

main() {
    // f requires a BException capability; the target type provides only AException
    let g: () throws AException -> Unit = f
    try {
        g()
    } catch (e: Exception) {
    }
    return 0
}
