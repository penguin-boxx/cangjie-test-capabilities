// Rewrite audit: §3.2, §5.3.2; generated declarations.
// Calls introduced by macro expansion participate in ordinary declaration inference.
//
// DEPENDENCE: audit_macro.cj
// EXEC: %compiler %cmp_macro --experimental --enable-checked-exceptions audit_macro.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import audit_macro.*
class AE <: Exception {}
func risky(): Unit { throw AE() }
@Insert
func generated(): Unit {}
main(): Int64 {
    try { generated() } catch (e: AE) { return 0 }
    return 1
}
