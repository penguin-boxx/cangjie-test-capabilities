// Checked exceptions ("ABI and reflection"): capability parameters are stripped after type
// checking -- no runtime parameters, no calling-convention change, no storage, and a capturing
// type has the layout of one without the clause. Erasure was argued from the architecture
// ('capTys' are deliberately outside 'typeArgs', so CHIR and codegen never see them) but never
// pinned by a test, which the 2026-08-30 review noted.
//
// This is the runnable half: a clause-bearing program and its clause-free twin must behave
// identically, including through a function value and a capturing type. The symbol-level half --
// comparing mangled names between the twins -- is 'erasure_symbols.cj'.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class EException <: Exception {}

class Capturing
captures EException {
    init() {}
    func run(): Int64 { 42 }
}

func withClause(x: Int64): Int64
throws EException {
    return x + 1
}

func withoutClause(x: Int64): Int64 {
    return x + 1
}

main(): Int64 {
    try {
        let a: (Int64) -> Int64 = withoutClause
        let c = Capturing()
        if (withClause(41) != 42 || a(41) != 42 || c.run() != 42) {
            return 1
        }
    } catch (e: EException) {
        return 1
    }
    return 0
}
