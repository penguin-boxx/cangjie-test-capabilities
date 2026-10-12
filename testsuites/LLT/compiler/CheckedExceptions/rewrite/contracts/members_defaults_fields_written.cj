// Rewrite acceptance: §3–5 equivalence control.
// Authoritative-clause twin of members_defaults_fields; both variants must compile and run identically.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

class Holder {
    let value = source()
    init() throws AE {}
    init(unused: Bool) throws AE {}
}
class Worker {
    func run(): Unit throws AE { risky() }
    prop callback: () throws AE -> Unit { get() { risky } }
}
func withDefault(x!: Int64 = source()): Int64 throws AE { x }
func bound(): Unit throws AE { let f = Worker().run; f() }
main(): Int64 {
    var caught = 0
    try { let h = Holder() } catch (e: AE) { caught++ }
    try { let h = Holder(true) } catch (e: AE) { caught++ }
    try { withDefault() } catch (e: AE) { caught++ }
    try { bound() } catch (e: AE) { caught++ }
    try { Worker().callback() } catch (e: AE) { caught++ }
    return if (caught == 5) { 0 } else { 1 }
}
func source(): Int64 throws AE { throw AE() }
func risky(): Unit throws AE { throw AE() }
