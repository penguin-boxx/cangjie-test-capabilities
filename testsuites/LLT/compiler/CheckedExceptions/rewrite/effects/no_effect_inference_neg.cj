// Rewrite acceptance: §5.4.1.
// A private declaration cannot infer its performs clause.
//
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-Get'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex no_effect_inference_neg\.cj:14:[0-9]+:

import stdx.effect.*
class Get <: Command<Int64> {}
class AE <: Exception {}

func absent(): Int64 { perform Get() } // ERROR
main(): Int64 { 0 }
