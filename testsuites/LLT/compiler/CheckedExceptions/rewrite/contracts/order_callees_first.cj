// Rewrite acceptance: §3.4.3, §3.5, §5.3.2–3.
// Equivalent source-order permutations must infer the same joined and returned contracts.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
func leafB(): Unit { throw BE() }

func leafA(): Unit { throw AE() }

func factory() { leafA }

func throughFactory(): Unit { factory()() }

func joined(flag: Bool): Unit {
    let fn = if (flag) { leafA } else { leafB }
    fn()
}

main(): Int64 {
    var caught = 0
    try { joined(true) } catch (e: AE) { caught++ } catch (e: BE) { return 1 }
    try { joined(false) } catch (e: BE) { caught++ } catch (e: AE) { return 1 }
    let value = factory() // forming and returning a reference requires nothing
    try { value() } catch (e: AE) { caught++ }
    try { throughFactory() } catch (e: AE) { caught++ }
    return if (caught == 4) { 0 } else { 1 }
}
