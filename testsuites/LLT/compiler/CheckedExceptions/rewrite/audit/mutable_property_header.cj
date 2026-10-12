// Rewrite audit: §3.2, §3.3.2.
// A property header supplies both accessors and places requirements on both reads and writes.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class Holder {
    mut prop value: Int64 throws AE {
        get() { throw AE() }
        set(v) { throw AE() }
    }
}
main(): Int64 {
    let h = Holder()
    var caught = 0
    try { let value = h.value } catch (e: AE) { caught++ }
    try { h.value = 2 } catch (e: AE) { caught++ }
    return if (caught == 2) { 0 } else { 1 }
}
