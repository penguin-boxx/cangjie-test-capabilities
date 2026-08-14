// Checked exceptions (§6.4): throwing an UncheckedException subtype requires no
// capability; unchecked exceptions remain catchable like any exception.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class RequestException <: UncheckedException {}

func noClause() {
    throw RequestException() // no capability needed
}

main() {
    try {
        noClause()
        return 1
    } catch (e: RequestException) {
    }
    // catching via the base class works too
    try {
        noClause()
        return 1
    } catch (e: UncheckedException) {
    }
    return 0
}
