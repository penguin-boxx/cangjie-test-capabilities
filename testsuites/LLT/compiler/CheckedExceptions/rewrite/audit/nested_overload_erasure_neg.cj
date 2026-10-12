// Rewrite audit: §3.7.
// Clause erasure reaches function types nested inside invariant generic parameter types.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(duplicate|redefinition|conflict|same signature|redeclared)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex nested_overload_erasure_neg\.cj:13:[0-9]+:

class AE <: Exception {}
class Box<T> { init() {} }
func choose(x: Box<() throws AE -> Unit>): Unit {}
func choose(x: Box<() -> Unit>): Unit {} // ERROR: same erased signature
main(): Int64 { 0 }
