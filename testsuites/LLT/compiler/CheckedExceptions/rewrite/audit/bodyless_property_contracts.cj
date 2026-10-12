// Rewrite audit: §3.2, §3.8.
// Bodyless property headers and bodyless split accessors declare distinct read and write requirements.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
interface API {
    prop value: Int64 throws AE
    mut prop split: Int64 {
        get() throws AE
        set(v) throws BE
    }
}
class Impl <: API {
    public prop value: Int64 { get() throws AE { throw AE() } }
    public mut prop split: Int64 {
        get() throws AE { throw AE() }
        set(v) throws BE { throw BE() }
    }
}
main(): Int64 {
    let h: API = Impl()
    var caught = 0
    try { let value = h.value } catch (e: AE) { caught++ }
    try { let value = h.split } catch (e: AE) { caught++ }
    try { h.split = 1 } catch (e: BE) { caught++ }
    return if (caught == 3) { 0 } else { 1 }
}
