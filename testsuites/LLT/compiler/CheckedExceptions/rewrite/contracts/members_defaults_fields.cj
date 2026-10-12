// Rewrite acceptance: §3.2–3, §5.3.2.
// Complete member, accessor, default-expression and field-initializer dependencies before their consumers.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}

class Holder {
    let value = source()
    init() {}
    init(unused: Bool) {}
}
class Worker {
    func run(): Unit { risky() }
    prop callback: () throws AE -> Unit { get() { risky } }
}
func withDefault(x!: Int64 = source()): Int64 { x }
func bound(): Unit { let f = Worker().run; f() }
main(): Int64 {
    var caught = 0
    try { let h = Holder() } catch (e: AE) { caught++ }
    try { let h = Holder(true) } catch (e: AE) { caught++ }
    try { withDefault() } catch (e: AE) { caught++ }
    try { bound() } catch (e: AE) { caught++ }
    try { Worker().callback() } catch (e: AE) { caught++ }
    return if (caught == 5) { 0 } else { 1 }
}
func source(): Int64 { throw AE() }
func risky(): Unit { throw AE() }
