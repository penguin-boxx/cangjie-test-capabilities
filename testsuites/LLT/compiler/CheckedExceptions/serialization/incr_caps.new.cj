class IncrExc <: Exception {}

public func risky(): Int64 throws IncrExc {
    throw IncrExc()
}

// The clause is gone in this version: the call to the CACHED 'risky' must still demand IncrExc.
public func ok(): Int64 {
    return risky()
}

main() {
    return 0
}
