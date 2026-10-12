// Rewrite acceptance: §3.3.2, §5.3.2.
// Static initialization has no caller from which to infer a capability.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex static_initializer_neg\.cj:14:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

class Source {
    static let value = risky() // ERROR
}
func risky(): Int64 { throw AE() }
main(): Int64 { 0 }
