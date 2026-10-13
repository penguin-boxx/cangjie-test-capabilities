// Section 6 acceptance: §6.3.2: positive functional result positions are transformed recursively.
// DEPENDENCE: r6legacy.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt r6legacy.cj -o r6legacy.%middle
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions=error r6legacy.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex nested_result_neg\.cj:14:[0-9]+:

@AssumeThrows[AE]
import r6legacy.*
func caller(): Unit throws () {
    let f = try { nested()() } catch (e: AE) { { => 0 } }
    f() // ERROR: second returned function retains the assumption
}
main(): Int64 { 0 }
