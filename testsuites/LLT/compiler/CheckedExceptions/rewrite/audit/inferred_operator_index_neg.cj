// Rewrite audit: §3.2, §3.3.1, §5.3.2; operator synthesis.
// Operator and index inference must reach ordinary caller requirements.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*(AE|BE))
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex inferred_operator_index_neg\.cj:20:[0-9]+:
// ASSERT: regex inferred_operator_index_neg\.cj:21:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}
struct Value {
    operator func +(other: Value): Value { throw AE() }
    operator func [](index: Int64): Int64 { throw BE() }
}
func add(v: Value): Value { v + v }
func index(v: Value): Int64 { v[0] }
func caller(v: Value): Unit throws () {
    add(v) // ERROR: inferred operator requirement
    index(v) // ERROR: inferred indexing requirement
}
main(): Int64 { 0 }
