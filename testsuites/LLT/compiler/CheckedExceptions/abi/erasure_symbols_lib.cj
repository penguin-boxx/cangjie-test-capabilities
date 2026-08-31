// The clause-bearing half of the erasure twin pair; 'erasure_symbols_plain.cj' is the same source
// with every clause removed. Their symbol tables must be identical.

package twin

public class EException <: Exception {}

public class Holder {
    public init() {}
    public func run(x: Int64): Int64 { x + 1 }
}

public func withClause(x: Int64): Int64
throws EException {
    return x + 1
}

public func helper(f: (Int64) throws EException -> Int64, x: Int64): Int64
throws EException {
    return f(x)
}
