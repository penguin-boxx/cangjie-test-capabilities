// Rewrite audit: §3.9.3, §5.3.1 under §6.5.
// Static methods do not acquire receiver captures even on a capturing class.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex capturing_static_neg\.cj:13:[0-9]+:

class AE <: Exception {}
class Worker captures AE {
    init() {}
    static func bad(): Unit throws () { throw AE() } // ERROR: no receiver supply
}
main(): Int64 { 0 }
