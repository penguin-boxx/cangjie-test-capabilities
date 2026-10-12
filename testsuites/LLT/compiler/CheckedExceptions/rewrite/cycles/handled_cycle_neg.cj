// Rewrite acceptance: §5.3.4 rewrite policy.
// An active inferred contract cannot satisfy its own dependency; do not infer an SCC fixpoint.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*recursive capability inference
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

class AE <: Exception {}
class BE <: Exception {}
func first(): Unit { try { second() } catch (e: AE) {} }
func second(): Unit { first(); throw AE() }
main(): Int64 { 0 }
