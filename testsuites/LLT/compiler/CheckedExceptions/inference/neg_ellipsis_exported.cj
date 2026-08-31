// Checked exceptions (interaction with an explicit throws): the `...` marker opens a clause to
// inference, so it is not allowed on an exported declaration, whose list must not depend on inference.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error: '...' is not allowed in the 'throws' clause of an exported declaration

class AException <: Exception {}

public func api() throws AException, ... {
    throw AException()
}

public open class K {
    protected func hook() throws AException, ... {
        throw AException()
    }
}

public interface I {
    func m(): Unit
    throws AException, ...
}

main() {
    return 0
}
