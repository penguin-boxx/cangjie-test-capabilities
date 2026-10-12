// Rewrite audit: §3.3.2, §5.3.2; constructor ordering.
// Constructors requested before field declarations infer all initializer requirements.
//
// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AE <: Exception {}
class BE <: Exception {}
func create(): Unit { let h = Holder() }
class Holder {
    init() {}
    init(unused: Bool) {}
    let first = sourceA()
    let second = sourceB()
}
func sourceA(): Int64 { throw AE() }
func sourceB(): Int64 { throw BE() }
main(): Int64 {
    var caught = 0
    try { create() } catch (e: AE) { caught++ } catch (e: BE) { return 1 }
    try { let h = Holder(true) } catch (e: AE) { caught++ } catch (e: BE) { return 2 }
    return if (caught == 2) { 0 } else { 3 }
}
