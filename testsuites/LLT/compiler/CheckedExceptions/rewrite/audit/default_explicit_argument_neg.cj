// Rewrite audit: §3.3.2, §5.3.2.
// Default-expression requirements belong to the declaration even when the caller supplies the argument.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex default_explicit_argument_neg\.cj:14:[0-9]+:

class AE <: Exception {}
func source(): Int64 { throw AE() }
func withDefault(x!: Int64 = source()): Int64 { x }
public func caller(): Int64 {
    withDefault(x: 42) // ERROR: the declared contract is not specialized by omission
}
main(): Int64 { 0 }
