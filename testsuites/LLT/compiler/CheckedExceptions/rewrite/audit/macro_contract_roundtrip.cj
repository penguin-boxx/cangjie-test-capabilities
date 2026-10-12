// Structured macro ASTs preserve effective property and function contracts.
// DEPENDENCE: audit_macro.cj
// EXEC: %compiler %cmp_macro --experimental --enable-checked-exceptions audit_macro.cj
// EXEC: %run_macro %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import audit_macro.*
class AE <: Exception {}
@RoundTrip
interface Reader {
    prop value: Int64 throws AE { get() }
}
@RoundTrip
class Source <: Reader {
    public prop value: Int64 throws AE {
        get() { throw AE() }
    }
}
@RoundTrip
func invoke(f: () throws AE -> Int64): Int64 throws AE { f() }
main(): Int64 {
    let reader: Reader = Source()
    try { invoke { => reader.value } } catch (e: AE) { return 0 }
    return 1
}
