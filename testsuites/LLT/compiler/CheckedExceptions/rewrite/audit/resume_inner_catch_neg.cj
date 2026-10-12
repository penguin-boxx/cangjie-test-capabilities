// Rewrite audit: §5.4.5.
// A catch inside a performer cannot discharge a resume-throwing site in its caller handler.
//
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex resume_inner_catch_neg\.cj:18:[0-9]+:

import stdx.effect.*
class Ask <: Command<Int64> {}
class AE <: Exception {}
func performer(): Int64 performs Ask {
    try { perform Ask() } catch (e: AE) { 0 }
}
public func handler(): Int64 {
    try { performer() } handle (_: Ask) {
        resume throwing AE() // ERROR: handler cannot rely on the performer's nested catch
    }
}
main(): Int64 { 0 }
