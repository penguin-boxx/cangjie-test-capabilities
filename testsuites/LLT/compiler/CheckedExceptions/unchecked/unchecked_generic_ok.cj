// Checked exceptions (§3.2 rule 5, exemption): type parameters may appear in
// clauses; a capability requirement whose type INSTANTIATES to an unchecked
// exception type is trivially satisfied at the call site.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class RequestException <: UncheckedException {}
class AException <: Exception {}

func safeThrow<E>(e: E): Nothing where E <: Exception throws E {
    throw e
}

main() {
    // no capability in scope: the requirement instantiates to an unchecked type
    try {
        safeThrow<RequestException>(RequestException())
        return 1
    } catch (e: RequestException) {
    }
    // the checked instantiation still demands a capability (provided here by try)
    try {
        safeThrow<AException>(AException())
        return 1
    } catch (e: AException) {
    }
    return 0
}
