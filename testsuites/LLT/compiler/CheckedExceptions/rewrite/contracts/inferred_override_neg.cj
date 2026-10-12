// Rewrite acceptance: §3.8, §5.3.1.
// Complete an inferred override before validating its interface contract.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(not covered|override|capability|mismatched types)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex inferred_override_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

interface I { func run(): Unit }
class Impl <: I {
    public func run(): Unit { risky() } // ERROR: effective visibility permits inference, not widening I
}
func risky(): Unit { throw AE() }
main(): Int64 { 0 }
