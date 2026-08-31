// Checked exceptions: a declaration carries at most one clause of each kind, exactly as it carries
// one `where` block; a second is an error. Generated code that adds requirements merges entries into
// the existing clause, which also preserves its inference status -- appending a clause could flip it.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: duplicate 'throws' clause
// ASSERT: scan error: duplicate 'captures' clause

class AException <: Exception {}
class BException <: Exception {}

func f(): Unit throws AException throws BException {
    throw AException()
}

// a `where` block between the two does not make a second clause legal either
func g<T>(x: T): Unit throws AException where T <: ToString throws BException {
    throw AException()
}

class Twice captures AException captures BException {
    init() {}
}

main() {
    return 0
}
