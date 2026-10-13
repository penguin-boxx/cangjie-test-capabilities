// Section 6 acceptance: §6.3.2–3: assumptions do not widen argument input types.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex write_argument_neg\.cj:14:[0-9]+:

@AssumeThrows[AE]
import r6legacy.*
func fail(): Int64 throws AE { throw AE() }
func caller(r: Registry): Unit throws AE {
    accept(fail) // ERROR: declared input remains clause-free
}
main(): Int64 { 0 }
