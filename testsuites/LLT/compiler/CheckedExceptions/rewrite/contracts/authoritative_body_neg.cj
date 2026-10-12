// Rewrite acceptance: §5.3.1, §5.3.5.
// Published authoritative contracts must not skip validation of unused bodies.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex authoritative_body_neg\.cj:14:[0-9]+:
// ASSERT: regex authoritative_body_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

public func exported(): Unit { risky() } // ERROR: omitted exported clause is empty
func pinned(): Unit throws () { risky() } // ERROR: explicit empty clause cannot grow
func risky(): Unit { throw AE() }
main(): Int64 { 0 }
