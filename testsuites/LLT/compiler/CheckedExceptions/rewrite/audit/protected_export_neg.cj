// Rewrite audit: §5.3.1.
// Protected members of exported classes have authoritative empty omitted clauses.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex protected_export_neg\.cj:12:[0-9]+:

class AE <: Exception {}
public open class Worker {
    protected func work(): Unit { throw AE() } // ERROR: externally accessible through subclasses
}
main(): Int64 { 0 }
