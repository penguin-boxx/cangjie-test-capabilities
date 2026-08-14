// Checked exceptions (§3.2): a declaration may carry at most one `throws` clause;
// a second clause (even separated by a `where` block) is a parse error.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: duplicate 'throws' clause

class AException <: Exception {}
class BException <: Exception {}

func f(): Unit throws AException throws BException {
    throw AException()
}

main() {
    return 0
}
