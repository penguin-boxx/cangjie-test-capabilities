// Rewrite audit: §3.9, §5.1.2 under §6.5.
// Erasing an unchecked capture entry must not erase a checked construction requirement.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(Cannot find a capability.*AE)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex capturing_checked_specialization_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class UE <: UncheckedException {}
class Holder<E> captures E where E <: Exception { init() {} }
func checked(): Unit throws () {
    let noRequirement = Holder<UE>()
    let requiresAE = Holder<AE>() // ERROR: this specialization still demands AE
}
main(): Int64 { 0 }
