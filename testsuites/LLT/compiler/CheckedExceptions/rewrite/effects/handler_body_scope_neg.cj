// Rewrite acceptance: §3.3, §5.4.
// A handle body cannot discharge another perform against its own handler.
//
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-Get'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex handler_body_scope_neg\.cj:17:[0-9]+:

import stdx.effect.*
class Get <: Command<Int64> {}
class AE <: Exception {}

func value(): Int64 performs Get { perform Get() }
main(): Int64 {
    try { value() } handle (_: Get) {
        let again = perform Get() // ERROR
        resume with again
    }
    return 0
}
