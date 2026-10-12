// Rewrite audit: §3–5 equivalence control.
// Written-clause control for constructor_before_fields; inference must preserve the same behavior.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
func create(): Unit throws AE, BE { let h = Holder() }
class Holder {
    init() throws AE, BE {}
    init(unused: Bool) throws AE, BE {}
    let first = sourceA()
    let second = sourceB()
}
func sourceA(): Int64 throws AE { throw AE() }
func sourceB(): Int64 throws BE { throw BE() }
main(): Int64 {
    var caught = 0
    try { create() } catch (e: AE) { caught++ } catch (e: BE) { return 1 }
    try { let h = Holder(true) } catch (e: AE) { caught++ } catch (e: BE) { return 2 }
    return if (caught == 2) { 0 } else { 3 }
}
