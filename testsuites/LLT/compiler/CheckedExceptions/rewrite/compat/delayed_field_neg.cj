// Section 6 acceptance: §6.3.2: field obtained inside a handler still requires AE when invoked later.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex delayed_field_neg\.cj:14:[0-9]+:

@AssumeThrows[AE]
import r6legacy.*
func caller(r: Registry): Unit throws () {
    let f = try { r.worker } catch (e: AE) { { => 0 } }
    f() // ERROR: capability belongs to the invocation
}
main(): Int64 { 0 }
