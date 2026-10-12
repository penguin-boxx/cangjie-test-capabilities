// Rewrite audit: §3.5, §5.3.3.
// An unused literal still needs lexical supply; it does not infer its own throws list.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex uncalled_literal_neg\.cj:13:[0-9]+:

class AE <: Exception {}
func risky(): Unit throws AE { throw AE() }
public func outer(): Unit {
    let unused = { => risky() } // ERROR: no expected clause and no enclosing supply
}
main(): Int64 { 0 }
