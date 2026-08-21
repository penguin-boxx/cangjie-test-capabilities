// Checked exceptions (capability parameters in declarations): a declaration may carry several `throws`
// clauses; their entries union into one list. This serves generated code -- a macro appends a clause
// instead of merging into an existing one -- and conditional compilation. `captures` unions the same way.
// Positive: every form parses, the unioned lists are what the bodies are checked against, and it runs.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}
class CException <: Exception {}
class DException <: Exception {}

// two clauses, the second carrying several entries
func step() throws AException throws BException, CException {
    throw AException()
}

// a `where` block may sit between the clauses, in either order
func generic<T>(x: T) throws AException where T <: ToString throws BException {
    throw BException()
}

// unioned lists are what call sites must satisfy: all three entries are required here
func callStep() throws AException, BException, CException {
    step()
}

// `...` may repeat across the clauses of one declaration, idempotently: any occurrence opens
// the combined list to inference, so the DException thrown below needs no explicit entry
func opened() throws AException, ... throws BException, ... {
    throw AException()
}

func callOpened() throws AException, BException {
    opened()
}

// captures unions the same way; entries follow the `throws` entry rules, aliases included
type Two = (CException, DException)

class Multi captures AException captures BException, Two {
    init() {}
    func a() { throw AException() }
    func b() { throw BException() }
    func c() { throw CException() }
    func d() { throw DException() }
}

main() {
    try {
        callStep()
        callOpened()
        generic(1)
    } catch (e: Exception) {}
    try {
        let m = Multi()
        m.a()
    } catch (e: Exception) {}
    return 0
}
