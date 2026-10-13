// Section 6 acceptance: §6.1–2: warning suppression preserves trusted signatures and enabled producer identity.
// DEPENDENCE: r6warn.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=warn -Woff checked-exceptions r6warn.cj -o r6warn.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6warn.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex warn_metadata_neg\.cj:13:[0-9]+:

import r6warn.*
public func caller(): Unit {
    violates() // trusted empty declaration is permitted
    declared() // ERROR: trusted written AE is still required
}
main(): Int64 { 0 }
