// Rewrite audit: §3.6, §5.1.2, §5.3.3.
// Completing an unchecked instantiation must not erase requirements from later checked instantiations.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(mismatched types|capability)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex generic_cache_wrong_instance_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class UE <: UncheckedException {}
func fail<E>(e: E): Unit where E <: Exception { throw e }
main(): Int64 {
    let unchecked: (UE) -> Unit = fail<UE>
    let checked: (AE) -> Unit = fail<AE> // ERROR: AE still requires a capability
    return 0
}
