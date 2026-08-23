// A dependency compiled WITHOUT checking, handing out functions: the assumption over it has to
// reach the values it returns, not only the calls that return them.

package legacy_callbacks

public class LegacyException <: Exception {}

public func getWorker(): () -> Int64 {
    return { => throw LegacyException() }
}

public class Registry {
    public let worker: () -> Int64
    public init() {
        worker = { => throw LegacyException() }
    }
    public func direct(): Int64 { 1 }
}
