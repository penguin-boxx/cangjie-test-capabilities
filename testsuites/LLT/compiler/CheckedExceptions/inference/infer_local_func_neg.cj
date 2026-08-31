// Checked exceptions (which declarations are inferred): because a local function has a capability
// list of its own rather than the enclosing scopes', a requirement inside it is not discharged by a
// `try` that merely encloses its declaration -- the call site pays, wherever it is.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan Cannot find a capability for 'Class-AException'

class AException <: Exception {}

public func calledOutside(): Unit {
    func inner(): Unit {
        throw AException()
    }
    try {
        // the try handles AException, but nothing calls inner in here
    } catch (e: AException) {
    }
    inner() // error: this call site supplies nothing
}

main() {
    return 0
}
