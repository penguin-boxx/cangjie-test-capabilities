// Checked exceptions (compatibility): the clause grammar is unconditional -- every clause position
// is a parse error in the language without them, so recognizing the soft keywords there changes no
// valid program. What the flag decides is what the clauses mean: with checking off they impose no
// obligations, so the undeclared throw below is accepted exactly as it is today.

// EXEC: %compiler %cmp_opt %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

func declared() throws AException {
    throw AException()
}

func undeclared(): Unit { // no clause, and no obligation without checking
    throw BException()
}

class Capturing captures AException {
    init() {}
    func use(): Unit { declared() }
}

main() {
    try {
        declared()      // no capability needed: checking is off
        undeclared()
    } catch (e: Exception) {}
    return 0
}
