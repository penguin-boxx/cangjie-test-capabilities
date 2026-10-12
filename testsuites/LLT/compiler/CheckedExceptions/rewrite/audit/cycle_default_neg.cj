// Rewrite audit: §5.3.4 rewrite policy; default helper ownership.
// A default expression creates a contract cycle even when the recursive call supplies the argument.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(recursive capability inference)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

func first(x!: Int64 = second()): Int64 { x }
func second(): Int64 { first(x: 0) }
main(): Int64 { 0 }
