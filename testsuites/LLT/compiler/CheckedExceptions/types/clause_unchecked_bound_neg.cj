// Checked exceptions (capability list aliases, rule 2): a type parameter is admitted in a clause --
// a requirement that instantiates to an unchecked type is trivially satisfied instead -- unless its
// own bound is unchecked, in which case every instantiation of it is, and the entry can never
// require a capability.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: unchecked exception type 'T' is not allowed in a 'throws' clause
// ASSERT: scan error: unchecked exception type 'U' is not allowed in a 'throws' clause

class MyUnchecked <: UncheckedException {}

func f<T>(): Unit throws T where T <: MyUnchecked {}

func g<U>(): Unit throws U where U <: UncheckedException {}

func ok<E>(e: E): Unit throws E where E <: Exception { // admitted: may instantiate either way
    throw e
}

main() {
    return 0
}
