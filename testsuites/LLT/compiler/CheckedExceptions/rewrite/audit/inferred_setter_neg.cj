// Rewrite audit: §3.2, §3.8, §5.3.2; accessor synthesis.
// An inferred setter requirement must survive property assignment lowering.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex inferred_setter_neg\.cj:18:[0-9]+:

class AE <: Exception {}
class Holder {
    mut prop value: Int64 {
        get() { 1 }
        set(v) { throw AE() }
    }
}
func caller(h: Holder): Unit throws () {
    h.value = 2 // ERROR: assignment invokes the inferred setter
}
main(): Int64 { 0 }
