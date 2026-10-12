// Rewrite acceptance: §3.3, §5.3.2.
// Completing a callee from inside a handler must not lend that handler to the callee body.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex dependency_scope_isolation_neg\.cj:13:[0-9]+:

class AE <: Exception {}
main(): Int64 {
    try { risky() } catch (e: AE) {} // first contract request occurs under a supply
    risky() // ERROR: the callee must still require AE outside the handler
    return 0
}
func risky(): Unit { throw AE() }
