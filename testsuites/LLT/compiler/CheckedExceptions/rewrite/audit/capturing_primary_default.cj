// Rewrite audit: §3.9, §6.5.
// Primary and implicit default constructors remain legal without Modal and demand captured capabilities.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class Primary captures AE {
    Primary(let value: Int64) {}
    func fail(): Unit throws () { throw AE() }
}
class Default captures AE {
    func fail(): Unit throws () { throw AE() }
}
class Empty captures () { Empty(let value: Int64) {} }
main(): Int64 {
    let e = Empty(7)
    var caught = 0
    try { Primary(e.value).fail() } catch (x: AE) { caught++ }
    try { Default().fail() } catch (x: AE) { caught++ }
    return if (caught == 2) { 0 } else { 1 }
}
