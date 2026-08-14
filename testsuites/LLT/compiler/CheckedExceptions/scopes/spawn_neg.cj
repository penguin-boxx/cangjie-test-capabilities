// Checked exceptions (author ruling on spawn): a spawn body starts with an EMPTY
// capability scope stack — enclosing try-catch and clause capabilities are
// unreachable inside it.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-AException'

class AException <: Exception {}

func f() throws AException {
    spawn {
        throw AException() // error: the clause capability does not reach spawn bodies
    }
}

main() {
    try {
        f()
    } catch (e: AException) {
    }
    return 0
}
