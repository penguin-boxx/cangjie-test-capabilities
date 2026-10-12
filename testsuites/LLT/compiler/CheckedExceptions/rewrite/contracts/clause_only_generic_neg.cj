// Rewrite acceptance: §3.6.
// A callback clause cannot infer exception type variables.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(infer|type argument|type parameter)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex clause_only_generic_neg\.cj:16:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

func accepts<E>(f: () throws E -> Unit): Unit where E <: Exception {}
func risky(): Unit { throw AE() }
main(): Int64 {
    accepts(risky) // ERROR: E has no ordinary inference source
    return 0
}
