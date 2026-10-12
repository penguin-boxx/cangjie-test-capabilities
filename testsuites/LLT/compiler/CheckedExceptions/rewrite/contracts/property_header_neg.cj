// Rewrite acceptance: §3.2, §3.3.2.
// An explicit empty property-level clause must constrain the getter body.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex property_header_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

class Source {
    prop value: Int64 throws () {
        get() { throw AE() } // ERROR
    }
}
main(): Int64 { 0 }
