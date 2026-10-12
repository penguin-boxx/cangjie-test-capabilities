// Rewrite acceptance: §3.4.3, §5.3.3.
// Written twin of both order tests: inferred and written contracts have identical observable behavior.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
main(): Int64 {
    var caught = 0
    try { joined(true) } catch (e: AE) { caught++ } catch (e: BE) { return 1 }
    try { joined(false) } catch (e: BE) { caught++ } catch (e: AE) { return 1 }
    let value = factory() // forming and returning a reference requires nothing
    try { value() } catch (e: AE) { caught++ }
    try { throughFactory() } catch (e: AE) { caught++ }
    return if (caught == 4) { 0 } else { 1 }
}

func joined(flag: Bool): Unit throws AE, BE {
    let fn = if (flag) { leafA } else { leafB }
    fn()
}

func throughFactory(): Unit throws AE { factory()() }

func factory(): () throws AE -> Unit throws () { leafA }

func leafA(): Unit throws AE { throw AE() }

func leafB(): Unit throws BE { throw BE() }
