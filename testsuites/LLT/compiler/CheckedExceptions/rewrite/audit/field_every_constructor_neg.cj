// Rewrite audit: §3.3.2, §5.3.2; constructor ordering.
// A field initializer must be admitted by every constructor, including an authoritative empty one.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex field_every_constructor_neg\.cj:14:[0-9]+:

class AE <: Exception {}
class Holder {
    init() throws AE {}
    init(unused: Bool) throws () {}
    let value = source() // ERROR: second constructor cannot supply AE
}
func source(): Int64 { throw AE() }
main(): Int64 { 0 }
