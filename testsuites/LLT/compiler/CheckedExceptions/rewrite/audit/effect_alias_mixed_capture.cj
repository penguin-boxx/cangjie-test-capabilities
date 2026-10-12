// Rewrite audit: §3.9, §5.2, §5.4.
// Mixed aliases supply both capability kinds to a receiver; method requirements remain empty.
//
// EXEC: %compiler %cmp_opt %enableEH --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

import stdx.effect.*
class Ask <: Command<Int64> {}
class AE <: Exception {}
type Both = (Ask, AE)
class Worker captures Both {
    init() {}
    func run(fail: Bool): Int64 throws () performs () {
        if (fail) { throw AE() }
        perform Ask()
    }
}
main(): Int64 {
    let result = try { Worker().run(false) } catch (e: AE) { 0 } handle (_: Ask) { resume with 42 }
    let caught = try { Worker().run(true); false } catch (e: AE) { true } handle (_: Ask) { resume with 0 }
    return if (result == 42 && caught) { 0 } else { 1 }
}
