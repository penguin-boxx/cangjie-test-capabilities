// Rewrite acceptance: §3.3, §3.4.3, §5.3.3.
// A caller of an inferred joined value must require both branch capabilities.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-BE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex missing_join_neg\.cj:17:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

func use(flag: Bool): Unit { let f = if (flag) { a } else { b }; f() }
func a(): Unit { throw AE() }
func b(): Unit { throw BE() }
main(): Int64 {
    try { use(true) } catch (e: AE) {} // ERROR: BE is still required statically
    return 0
}
