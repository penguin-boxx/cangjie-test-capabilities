package r6legacy
public class AE <: Exception {}
public class BE <: Exception {}
public func plain(): Int64 { 1 }
public func factory(): () -> Int64 { { => 2 } }
public func nested(): () -> (() -> Int64) { { => { => 3 } } }
public func pair(): (() -> Int64, Int64) { ({ => 4 }, 4) }
public func callbacks(): Array<() -> Int64> { [{ => 5 }] }
public func accept(f: () -> Int64): Int64 { f() }
public class Registry {
    public var worker: () -> Int64 = { => 6 }
    public init() {}
    public func work(): Int64 { 7 }
    public mut prop callback: () -> Int64 {
        get() { worker }
        set(value) { worker = value }
    }
}
