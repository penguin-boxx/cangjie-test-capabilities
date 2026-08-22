// Checked exceptions (generics): capability parameters of argument functions are not considered in
// type argument inference -- there is no row unification. The argument's own list therefore never
// binds a type parameter of the callee: below, `T` and `G` occur in the block's capability list and
// `T` also in the return type, and the call is rejected because nothing else determines them.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: unable to infer generic argument of this function

class AException <: Exception {}

func f() throws AException {
    throw AException()
}

func g<T, G>(x: Int64, block: () throws (T, G) -> Unit): T
where T <: Exception, G <: Exception {
    throw Exception()
}

main() {
    // the block's list says AException, but that says nothing about T and G
    let bad: Int64 = g(0, f)
    return 0
}
