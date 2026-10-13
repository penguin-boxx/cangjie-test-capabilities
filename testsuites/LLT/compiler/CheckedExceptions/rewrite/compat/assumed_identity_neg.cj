// Section 6 acceptance: §6.3.2: generic identity and inferred factory retain the assumed callback type.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex assumed_identity_neg\.cj:16:[0-9]+:

@AssumeThrows[AE]
import r6legacy.*
func identity<T>(value: T): T { value }
func obtain(r: Registry) { identity(r.work) }
func caller(r: Registry): Unit throws () {
    let f = try { obtain(r) } catch (e: AE) { { => 0 } }
    f() // ERROR: already-derived function type is not reset at generic substitution
}
main(): Int64 { 0 }
