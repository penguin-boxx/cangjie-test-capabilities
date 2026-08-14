// Checked exceptions (§3.4): narrowing a capability list is NOT a subtype —
// the target type must cover every capability the source function requires.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error

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
