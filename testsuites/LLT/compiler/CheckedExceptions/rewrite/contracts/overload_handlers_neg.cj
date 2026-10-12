// Rewrite acceptance: §3.7.
// A suitable handler for another overload must not change the ordinary selected overload.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex overload_handlers_neg\.cj:16:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

func pick(x: Int64): Unit throws AE {}
func pick(x: String): Unit throws BE {}
main(): Int64 {
    try { pick(1) } catch (e: BE) {} // ERROR: selected Int64 overload still needs AE
    return 0
}
