// Rewrite audit: §5.3.4 rewrite policy; accessor synthesis.
// A property read participates in inferred contract cycles.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(recursive capability inference)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

class Holder {
    prop value: Int64 { get() { read(this) } }
}
func read(h: Holder): Int64 { h.value }
main(): Int64 { 0 }
