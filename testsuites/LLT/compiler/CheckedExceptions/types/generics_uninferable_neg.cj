// Checked exceptions (generics): capability argument inference follows type-argument inference and
// never the other way round, so a type parameter that occurs only in the clause gives inference
// nothing to work with -- the call needs an explicit type argument, as the positive case above it
// in generics_explicit.cj shows.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: unable to infer generic argument of this function

class GenericException<T> <: Exception {}

func onlyInClause<T>(): Nothing throws GenericException<T> {
    throw GenericException<T>()
}

main() {
    try {
        onlyInClause() // T occurs nowhere but the clause
    } catch (e: Exception) {
    }
    return 0
}
