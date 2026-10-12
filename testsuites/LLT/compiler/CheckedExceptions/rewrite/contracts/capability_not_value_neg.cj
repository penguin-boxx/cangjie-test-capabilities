// Rewrite acceptance: §3.1, §3.3.4.
// The intrinsic capability cannot be named as an ordinary parameter type.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*.*CanThrow
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex capability_not_value_neg\.cj:11:[0-9]+:

class AE <: Exception {}
func expose(c: CanThrow<AE>): Unit {} // ERROR
main(): Int64 { 0 }
