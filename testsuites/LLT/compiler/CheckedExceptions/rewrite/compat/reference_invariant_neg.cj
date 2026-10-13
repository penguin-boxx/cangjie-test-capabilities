// Section 6 acceptance: §6.3.2: an assumed reference reaches invariant ordinary generic inference.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex reference_invariant_neg\.cj:14:[0-9]+:

@AssumeThrows[AE]
import r6legacy.*
class Box<T> { init(value: T) {} }
func caller(r: Registry): Unit throws AE {
    let value: Box<() -> Int64> = Box(r.work) // ERROR: whole function type survives inference
}
main(): Int64 { 0 }
