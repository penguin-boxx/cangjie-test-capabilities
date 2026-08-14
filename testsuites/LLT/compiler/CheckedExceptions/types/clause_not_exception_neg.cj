// Checked exceptions (§3.2 rule 3): every type in a `throws` clause must be a
// subtype of class `Exception` (type parameters must be bounded by it).

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: type 'NotAnException' in 'throws' clause is not a subtype of class 'Exception'
// ASSERT: scan error: type 'Int64' in 'throws' clause is not a subtype of class 'Exception'
// ASSERT: scan error: type 'T' in 'throws' clause is not a subtype of class 'Exception'

class NotAnException {}

// A plain class is not an Exception.
func f(): Unit throws NotAnException {
}

// A primitive type is not an Exception.
func g(): Unit throws Int64 {
}

// An unbounded type parameter is not provably an Exception.
func h<T>(x: T): Unit throws T {
}

main() {
    return 0
}
