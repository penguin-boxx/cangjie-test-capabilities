// Rewrite audit: §3.10.2 under §6.5.
// Nominal casts and type patterns to capturing types are permitted and preserve usable receivers.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class Worker captures AE {
    init() {}
    func fail(): Unit throws () { throw AE() }
}
func invoke(x: Any): Unit throws () {
    match (x as Worker) {
        case Some(w) => w.fail()
        case None => ()
    }
}
func pattern(x: Any): Unit throws () {
    match (x) {
        case w: Worker => w.fail()
        case _ => ()
    }
}
main(): Int64 {
    var caught = 0
    try { invoke(Worker()) } catch (e: AE) { caught++ }
    try { pattern(Worker()) } catch (e: AE) { caught++ }
    return if (caught == 2) { 0 } else { 1 }
}
