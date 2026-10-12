// Rewrite audit: §5.2.5.
// A tuple alias cannot instantiate an exception type parameter as a capability-list variable.
//
// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: regex error:.*(constraint|bound|subtype|type argument|no matching|no match)
// ASSERT: regex-not error:.*(unexpected token|unclosed delimiter|expected .*found|unrecognized|undeclared identifier)
// ASSERT: scan-not Internal Compiler Error
// ASSERT: regex alias_is_not_exception_argument_neg\.cj:15:[0-9]+:

class AE <: Exception {}
class BE <: Exception {}
type Errors = (AE, BE)
func needs<E>(): Unit throws E where E <: Exception {}
main(): Int64 {
    needs<Errors>() // ERROR: tuple is not a subtype of Exception
    return 0
}
