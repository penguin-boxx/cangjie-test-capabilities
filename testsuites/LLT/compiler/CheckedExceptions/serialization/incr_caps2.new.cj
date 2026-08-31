class IncrExc2 <: Exception {}

public func risky2(): Int64 throws IncrExc2 {
    return 0
}

public func caller2(): Int64 {
    return risky2() // callee clause is new; this unchanged caller must be re-checked
}

main() {
    return 0
}
