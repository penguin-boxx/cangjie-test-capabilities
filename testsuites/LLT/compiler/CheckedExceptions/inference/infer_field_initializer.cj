// Checked exceptions (What is inferred, point 3): an instance field initializer has no capability
// scope of its own, so "it contributes to every inference-eligible constructor that evaluates it".
// A clause-free constructor therefore INFERS what its fields need, and the requirement lands on
// the construction site — where a 'try' can discharge it — instead of being reported at the
// initializer, which is what happened before: the initializer was checked against the
// constructors' written clauses alone, so a class with a throwing field and a clause-free 'init'
// could not be written at all.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class FE <: Exception {}

func mayThrow(): Int64 {
    throw FE()
}

class Holder {
    let value = mayThrow()   // contributes FE to every constructor below
    init() {}
    init(unused: Int64) {}   // a second constructor infers it too
}

// A constructor that declares the list discharges its fields' requirement itself.
class Declared {
    let value = mayThrow()
    init()
    throws FE {}
}

main(): Int64 {
    try {
        let h = Holder()          // requires FE, supplied by this try
        return 1
    } catch (e: FE) {
        try {
            let d = Declared()    // requires FE through the declared clause
            return 1
        } catch (e2: FE) {
            return 0
        }
    }
}
