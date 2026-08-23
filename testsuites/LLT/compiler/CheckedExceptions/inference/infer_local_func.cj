// Checked exceptions (which declarations are inferred): a local function declaration is an ordinary
// inference-eligible declaration with a capability list of its own. Its body resolves against that
// list rather than against the scopes it happens to be nested in, and its call sites pay for what it
// needs -- so a local function defined inside a `try` and called inside it is fine, and the list it
// acquires propagates to the enclosing declaration's own inferred list when it is called elsewhere.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

// the local function's inferred list reaches this declaration's list through the call
func propagates(): Int64 throws AException {
    func inner(): Int64 {
        throw AException()
    }
    inner()
}

// defined and called inside the try that handles what it throws
func dischargedLocally(): Int64 {
    try {
        func inner(): Int64 {
            throw BException()
        }
        inner()
    } catch (e: BException) {
        1
    }
}

// a local function nested in a local function
func nested(): Int64 throws AException {
    func outer(): Int64 {
        func innermost(): Int64 {
            throw AException()
        }
        innermost()
    }
    outer()
}

main(): Int64 {
    var caught = 0
    try {
        propagates()
    } catch (e: AException) {
        caught++
    }
    if (dischargedLocally() != 1) {
        return 1
    }
    try {
        nested()
    } catch (e: AException) {
        caught++
    }
    if (caught == 2) {
        return 0
    }
    return 1
}
