// Rewrite acceptance: §3.3.2, §5.3.2.
// A try supplies neither its catch nor its user-written finally body.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*Cannot find a capability for 'Class-AE'
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex catch_finally_scope_neg\.cj:16:[0-9]+:
// ASSERT: regex catch_finally_scope_neg\.cj:17:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}

func reject(): Unit throws () {
    try { throw AE() }
    catch (e: AE) { throw e } // ERROR
    finally { throw AE() } // ERROR
}
main(): Int64 { 0 }
