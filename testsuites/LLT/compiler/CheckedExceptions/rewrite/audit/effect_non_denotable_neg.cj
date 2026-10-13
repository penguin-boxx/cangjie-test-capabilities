// Rewrite audit: §3.3.4, §5.4.
// CanPerform cannot be named as an ordinary source-level parameter type.
//
// EXEC-PIPE-1: %compiler %cmp_opt %enableEH --enable-checked-effects error --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(CanPerform|undeclared)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex effect_non_denotable_neg\.cj:12:[0-9]+:

import stdx.effect.*
class Ask <: Command<Int64> {}
func take(x: CanPerform<Ask>): Unit {} // ERROR: no denotable capability type
main(): Int64 { 0 }
