// Rewrite acceptance: §3.4–6, §5.3.3.
// A completed inferred requirement cannot be erased by conversion.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types|inferred capability list)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex generic_invariant_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}
func risky(): Unit { throw AE() }
class Box<T> { let value: T; init(value: T) { this.value = value } }
main(): Int64 {
    let box: Box<() -> Unit> = Box(risky) // ERROR: invariant argument cannot erase the clause
    return 0
}
