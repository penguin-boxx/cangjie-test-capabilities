// Checked exceptions (§3.3): a throw (or call requiring a capability) with no
// suitable capability in scope is an error, with the proposal's wording (mode
// omitted pre-Modal per author ruling).

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'AException'
// ASSERT: scan Cannot find a capability for 'BException'

class AException <: Exception {}
class BException <: Exception {}

func throwsA() throws AException {
    throw AException()
}

func noClause() {
    throw AException() // error: no capability in scope
}

func wrongClause() throws BException {
    throwsA() // error: only BException capability available
}

main() {
    return 0
}
