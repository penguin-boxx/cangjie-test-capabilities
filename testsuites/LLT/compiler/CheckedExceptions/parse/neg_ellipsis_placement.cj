// Checked exceptions (interaction with an explicit throws): the '...' marker appears only as the
// last entry of a 'throws' clause, at most once.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '...' must be the last entry of a 'throws' clause

class AException <: Exception {}
class BException <: Exception {}

func notLast(): Unit throws AException, ..., BException {
    throw BException()
}

func twice(): Unit throws AException, ..., ... {
    throw AException()
}

main() {
    return 0
}
