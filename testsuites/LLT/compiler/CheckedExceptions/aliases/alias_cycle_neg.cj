// Checked exceptions (§6.1 / §3.10.2 rule 1): alias expansion is recursive, so a
// cyclic alias must be rejected rather than expanded forever.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error

class AException <: Exception {}

type Loop = (AException, Loop2)
type Loop2 = (AException, Loop)

func f() throws Loop {
    throw AException()
}

main() {
    return 0
}
