package r6meta
import stdx.effect.*
public class AE <: Exception {}
public class Ask <: Command<Int64> {}
public func work(): Int64 performs Ask throws AE { 8 }
public func nested(): Array<() performs Ask throws AE -> Int64> { [work] }
public class Capturing captures AE, Ask { public init() {} }
