// Checked exceptions (capability parameter inference): non-public callables without a clause get their
// capability lists inferred from their bodies; discharge removes entries;
// inferred lists propagate to callers through normal checking.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

func g() { // inferred: throws AException
    throw AException()
}

func f(): Int64 { // inferred: throws AException, BException
    g()
    if (false) {
        throw BException()
    }
    1
}

func discharged(): Int64 { // inferred: empty — everything handled locally
    try {
        f()
    } catch (e: AException) {
    } catch (e: BException) {
    }
    2
}

main() {
    let x = discharged() // callable with empty inferred list: no capability needed
    try {
        let _ = f() + x
    } catch (e: Exception) {
    }
    return 0
}
