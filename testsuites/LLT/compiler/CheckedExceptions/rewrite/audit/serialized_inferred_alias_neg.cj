// Rewrite audit: §3.10.1, §5.2.6, §5.3.3; signature publication.
// An imported inferred callback retains both requirements; the alias cannot conceal the uncovered entry.
//
// DEPENDENCE: auditlib.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions auditlib.cj -o auditlib.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions auditlib.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*BE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex serialized_inferred_alias_neg\.cj:15:[0-9]+:

import auditlib.*
public func caller(): Unit {
    let callback = factory()
    try { callback(false) } catch (e: AE) {} // ERROR: BE survives metadata and is not supplied
}
main(): Int64 { 0 }
