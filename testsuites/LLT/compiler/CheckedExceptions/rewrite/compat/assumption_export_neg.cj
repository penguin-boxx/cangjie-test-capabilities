// Section 6 acceptance: §6.2–3: the consumer exports derived callback clauses; the dependency stays unchanged.
// DEPENDENCE: r6legacy.cj r6bridge.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC: %compiler %cmp_opt %compile_lib_opt --experimental --enable-checked-exceptions=error r6legacy.%middle r6bridge.cj -o r6bridge.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle r6bridge.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex assumption_export_neg\.cj:16:[0-9]+:

import r6legacy.*
import r6bridge.*
public func caller(): Unit {
    plain() // original dependency still has no obligation
    let f = obtain() // obtaining an assumed reference requires nothing
    f() // ERROR: bridge result records AE
}
main(): Int64 { 0 }
