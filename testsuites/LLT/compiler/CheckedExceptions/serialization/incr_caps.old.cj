class IncrExc <: Exception {}

// Unchanged between the two versions: on the second (incremental) build its type is served from
// the cache, so its capability list must have survived the round trip.
public func risky(): Int64 throws IncrExc {
    throw IncrExc()
}

public func ok(): Int64 throws IncrExc {
    return risky()
}

main() {
    return 0
}
