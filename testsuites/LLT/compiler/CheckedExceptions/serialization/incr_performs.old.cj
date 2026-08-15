import stdx.effect.*

class GetNumber <: Command<Int64> {}

public func risky(): Int64 {
    return 0
}

public func caller(): Int64 {
    return risky()
}

main() {
    return 0
}
