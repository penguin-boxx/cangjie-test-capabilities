// Rewrite audit: §5.3.4 rewrite policy; constructor completion.
// Constructor-to-field-initializer dependencies participate in cycle detection.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(recursive capability inference)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error

func make(): Int64 { let value = Holder(); 1 }
class Holder {
    init() {}
    let value = make()
}
main(): Int64 { 0 }
