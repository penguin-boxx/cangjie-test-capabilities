// Rewrite audit: §3.2, §5.3.2; generated declarations.
// An inferred requirement introduced by a macro reaches the consuming call site.
//
// DEPENDENCE: audit_macro.cj
// EXEC: %compiler %cmp_macro --experimental --enable-checked-exceptions audit_macro.cj
// EXEC-PIPE-1: %run_macro %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex macro_inferred_neg\.cj:18:[0-9]+:

import audit_macro.*
class AE <: Exception {}
func risky(): Unit { throw AE() }
@Insert
func generated(): Unit {}
public func caller(): Unit {
    generated() // ERROR: expanded call to risky requires AE
}
main(): Int64 { 0 }
