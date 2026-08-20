// Checked exceptions (which declarations are inferred): public declarations are never inferred — their
// clauses are authoritative (explicit or empty by omission), so an undeclared
// checked throw in a public function is an error even with inference on.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-AException'

class AException <: Exception {}

public func api() {
    throw AException() // error: public, no clause, no inference
}

main() {
    return 0
}
