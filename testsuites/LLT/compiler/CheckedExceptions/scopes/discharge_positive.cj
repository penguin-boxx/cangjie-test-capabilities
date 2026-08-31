// Checked exceptions (capability argument inference): capability scopes — try-catch introduces one capability
// per catch-pattern type (E1|E2 introduces two); declared clauses cover bodies;
// contravariance: a base-type handler discharges subtype throws; catch/finally
// blocks are OUTSIDE the try's scope; try-with-resources initializers are inside.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

open class BaseException <: Exception {}
class AException <: BaseException {}
class BException <: Exception {}

func throwsA() throws AException {
    throw AException()
}

func propagate() throws AException, BException {
    throwsA() // discharged by the declared clause
    if (false) {
        throw BException()
    }
}

main() {
    // one capability per catch pattern; E1|E2 introduces two
    try {
        propagate()
    } catch (e: AException | BException) {
    }
    // contravariance: base handler covers subtype throw
    try {
        throwsA()
    } catch (e: BaseException) {
    }
    // rethrow from catch uses the OUTER scope, not the closed try's
    try {
        try {
            throwsA()
        } catch (e: AException) {
            throw AException() // needs the enclosing try's capability
        }
    } catch (e: AException) {
    }
    return 0
}
