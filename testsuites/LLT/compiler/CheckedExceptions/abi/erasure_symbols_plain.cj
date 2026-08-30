// The clause-free twin of 'erasure_symbols_lib.cj'.

package twin

public class EException <: Exception {}

public class Holder {
    public init() {}
    public func run(x: Int64): Int64 { x + 1 }
}

public func withClause(x: Int64): Int64 {
    return x + 1
}

public func helper(f: (Int64) -> Int64, x: Int64): Int64 {
    return f(x)
}
