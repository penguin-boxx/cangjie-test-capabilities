class IncrExc2 <: Exception {}

public func risky2(): Int64 {
    return 0
}

public func caller2(): Int64 {
    return risky2()
}

main() {
    return 0
}
