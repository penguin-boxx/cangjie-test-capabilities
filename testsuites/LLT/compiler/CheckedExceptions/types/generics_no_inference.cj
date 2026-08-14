// Checked exceptions (§3.6): capability parameters of argument functions are NOT
// considered in type-argument inference (no row unification).

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: mismatched types
// ASSERT: scan found '() throws (Class-AException) -> Nothing'

class AException <: Exception {}

func f() throws AException {
    throw AException()
}

func g<T, G>(x: Int64, block: () throws (T, G) -> Unit)
where T <: Exception, G <: Exception {
    try {
        block()
    } catch (e: Exception) {
    }
}

main() {
    // T and G cannot be inferred from f's capability list
    g(0, f)
    return 0
}
