// Rewrite audit: §5.3.4 rewrite policy; operator synthesis.
// An operator edge must not bypass active contract detection.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(recursive capability inference)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

struct Value {
    operator func +(other: Value): Value { combine(this) }
}
func combine(v: Value): Value { v + v }
main(): Int64 { 0 }
