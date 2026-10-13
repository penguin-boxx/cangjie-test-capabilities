// Section 6 acceptance: §6.3.2: both assumptions compose and function-value invocation retains both.
// DEPENDENCE: r6meta.cj
// EXEC: %compiler %cmp_opt %compile_lib_opt %enableEH r6meta.cj -o r6meta.%middle
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions=error r6meta.%middle %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability)
// ASSERT: regex error:.*Cannot find a capability.*AE
// ASSERT: regex error:.*Cannot find a capability.*Ask
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|undeclared identifier|unrecognized option)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex dual_assumptions_neg\.cj:17:[0-9]+:

@AssumeThrows[AE]
@AssumePerforms[Ask]
import r6meta.*
func caller(): Unit throws () performs () {
    let f = work
    f() // ERROR: both assumed components are required here
}
main(): Int64 { 0 }
