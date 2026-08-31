package p

class IncrExc <: Exception {}

// No clause: the list is inferred from this body, which raises nothing in this version.
func risky(): Unit {
    throw IncrExc()
}

// Unchanged between the two builds, and not inference-eligible: its clause is written.
public func caller(): Unit
throws () {
    risky()
}

main(): Int64 { caller(); return 0 }
