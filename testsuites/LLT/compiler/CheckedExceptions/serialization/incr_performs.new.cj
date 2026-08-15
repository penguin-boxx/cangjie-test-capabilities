import stdx.effect.*

class GetNumber <: Command<Int64> {}

public func risky(): Int64 performs GetNumber {
    return 0
}

public func caller(): Int64 {
    return risky() // must now error: caller supplies no GetNumber handler
}

main() {
    return 0
}
