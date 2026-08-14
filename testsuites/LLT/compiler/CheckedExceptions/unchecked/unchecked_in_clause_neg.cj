// Checked exceptions (§3.2 rule 5): a concrete unchecked exception type in a
// `throws` list is misleading (throwing it never needs a capability) and is
// rejected with a dedicated diagnostic.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error

class RequestException <: UncheckedException {}

func f() throws RequestException {
    throw RequestException()
}

main() {
    return 0
}
