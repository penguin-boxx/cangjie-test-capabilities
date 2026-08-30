// Checked exceptions ("Generics", author ruling of 2026-08-30): a type parameter that occurs ONLY
// in capability lists is rejected at the call site unless the argument is written. Inference
// ignores capability lists on purpose (no row unification), so nothing constrains such a
// parameter -- the language's general machinery would solve it at its bound, silently choosing a
// list the author never wrote. The text's own example is the first call below.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: type parameters 'G', 'T' of 'g' occur only in capability lists, which take no part in type-argument inference
// ASSERT: scan error: type parameter 'E' of 'h' occurs only in capability lists, which take no part in type-argument inference

class AException <: Exception {}

func f(): Unit
throws AException {
    throw AException()
}

// The example of the "Generics" section, verbatim in shape.
func g<T, G>(x: Int64, block: () throws (T, G) -> Unit): Unit
where T <: Exception, G <: Exception {}

// The variant whose parameter also reaches the callee's own clause: it used to be accepted and
// paid at the bound, which is exactly the silent choice the rule closes.
func h<E>(block: () throws E -> Unit): Unit
where E <: Exception
throws E {
    block()
}

main(): Int64 {
    g(0, f)
    h(f)
    return 0
}
